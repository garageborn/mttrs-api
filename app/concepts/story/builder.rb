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
        return unless link.present? && link.missing_story?
        return unless link.belongs_to_current_tenant?

        begin
          if build_story!
            Story::Refresh.run(id: model.id)
          end
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
          similar_link.similar.records.to_a
        end.flatten.compact.uniq.select(&:belongs_to_current_tenant?)
      end

      def model!(_params)
        similar_link = similar.detect { |link| link.story.present? }
        similar_link.try(:story) || Story.new(published_at: link.published_at)
      end

      def similar_stories
        similar.collect { |link| link.story }
      end

      def build_story!
        begin
          link.update_attributes(story: model)
        rescue ActiveRecord::RecordNotUnique
          return false
        end

        similar.each do |similar_link|
          next unless similar_link.missing_story?
          begin
            similar_link.update_attributes(story: model)
          rescue ActiveRecord::RecordNotUnique; end
        end
      end

      memoize :link, :similar
    end
  end
end
