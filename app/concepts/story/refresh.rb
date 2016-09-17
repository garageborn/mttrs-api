class Story
  class Refresh < Operation
    def process(params)
      Apartment::Tenant.each do
        Story::Refresh::Tenant.run(params)
      end
    end

    class Tenant < Operation
      def process(_params)
        byebug
        model.each { |story| process_story(story) }
      end

      private

      def model!(params)
        return Story.where(id: params[:id]) if params[:id].present?
        Story.joins(:story_links).where(story_links: { link_id: params[:link_id] }).distinct
      end

      def process_story(story)
        return story.destroy if story.links.blank?

        story.update_attributes(total_social: story.links.sum(:total_social).to_i)

        main_story_link = story.story_links.popular.first
        main_story_link.update_column(:main, true)
        story.story_links.where.not(id: main_story_link).update_all(main: false)
      end
    end
  end
end
