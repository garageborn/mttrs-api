class Story
  class AddLink < Operation
    extend Memoist

    action :find

    def process(*)
      return unless link.present?
      return if model == link.story || !match_category?

      if link.missing_story?
        link.update_attributes(story: model)
      else
        merge_story
      end

      RefreshStoryJob.perform_async(model.id)
    end

    private

    def link
      ::Link.find_by(id: @params[:link_id])
    end

    def match_category?
      model.category == link.category
    end

    def merge_story
      other_story = link.story
      other_story.links.find_each do |similar_link|
        similar_link.update_attributes(story: model)
      end
      Story::Destroy.run(id: other_story.id)
    end

    memoize :link
  end
end
