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

        link.update_attributes(story: model)
        similar.each do |link|
          next unless link.missing_story?
          link.update_attributes(story: model)
        end

        Story::Refresh.run(id: model.id)

        invalid! if link.missing_story?
      end

      private

      def link
        ::Link.find_by_id(@params[:link_id])
      end

      def similar
        link.similar.records.to_a.select(&:belongs_to_current_tenant?)
      end

      def model!(_params)
        similar_link = similar.detect { |link| link.story.present? }
        similar_link.try(:story) || Story.new(published_at: link.published_at)
      end

      memoize :link, :similar
    end
  end
end
