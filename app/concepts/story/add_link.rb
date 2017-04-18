class Story
  class AddLink < Operation
    extend Memoist

    action :find

    def process(*)
      return unless link.present?
      return if model == link.story || !valid_link?

      if link.missing_story?
        add_link
      else
        merge_story
      end
    end

    private

    def link
      ::Link.find_by(id: @params[:link_id])
    end

    def valid_link?
      link.belongs_to_current_tenant? && link.category == model.category
    end

    def add_link
      link.with_lock { link.update_attributes(story: model) }
      ::BlockedStoryLink.where(story: model, link: link).destroy_all
      RefreshStoryJob.perform_async(model.id)
    end

    def merge_story
      stories = [model, link.story]
      destination = stories.detect { |story| story.summary.present? } || stories.first
      other_story = stories.detect { |story| story != destination }

      other_story.links.find_each do |similar_link|
        similar_link.update_attributes(story: destination)
      end
      ::BlockedStoryLink.where(story: destination, link: link).destroy_all
      RefreshStoryJob.perform_async(destination.id)
      Story::Destroy.run(id: other_story.id)
    end

    memoize :link
  end
end
