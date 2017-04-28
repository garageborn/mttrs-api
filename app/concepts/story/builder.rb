class Story
  class Builder < Operation
    def process(params)
      Apartment::Tenant.each do
        Story::Builder::Tenant.run(link_id: params[:link_id])
      end
    end

    class Tenant < Operation
      extend Memoist

      def process(_params)
        return unless valid_link?

        begin
          build_story!
        ensure
          model.destroy unless model.reload.links.exists?
        end

        invalid! if link.missing_story?
      end

      private

      def link
        ::Link.find_by(id: @params[:link_id])
      end

      def model!(_params)
        return unless valid_link?
        story = stories.detect { |similar_story| similar_story.summary.present? } || stories.first
        story || Story.create(published_at: link.published_at, category: link.category)
      end

      def stories
        stories = [link.story] + link.similar.stories
        stories.compact.uniq.sort { |story| -story.links.size }
      end

      def build_story!
        update_link
        update_similar_links
        RefreshStoryJob.perform_async(model.id)
      end

      def update_link
        Story::AddLink.run(id: model.id, link_id: link.id)
      end

      def update_similar_links
        link.similar.links.each do |similar_link|
          Story::AddLink.run(id: model.id, link_id: similar_link.id)
        end
      end

      def valid_link?
        link.present? && link.belongs_to_current_tenant?
      end

      memoize :link, :stories
    end
  end
end
