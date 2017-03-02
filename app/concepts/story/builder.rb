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
        return unless link.present?
        return unless link.belongs_to_current_tenant?

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

      def similar
        link.similar.records.to_a.map do |similar_link|
          [similar_link, similar_link.similar.records.to_a]
        end.flatten.compact.uniq.select(&:belongs_to_current_tenant?)
      end

      def model!(_params)
        story = stories.detect { |similar_story| similar_story.summary.present? }
        story || stories.first || Story.new(published_at: link.published_at)
      end

      def stories
        stories = [link.story] + similar.map(&:story)
        stories.compact.uniq.sort { |story| -story.links.size }
      end

      def build_story!
        update_link
        update_similar_links
        Story::Refresh.run(id: model.id)
      end

      def update_link
        return if link.story == model

        if link.missing_story?
          link.update_attributes(story: model)
        else
          Story::Merger.run(id: link.story.id, destination_id: model.id)
        end
      end

      def update_similar_links
        similar.each do |similar_link|
          next if similar_link.story == model

          if similar_link.missing_story?
            similar_link.update_attributes(story: model)
          else
            Story::Merger.run(id: similar_link.story.id, destination_id: model.id)
          end
        end
      end

      memoize :link, :similar, :stories
    end
  end
end
