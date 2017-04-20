class Story
  class AddLink < Operation
    extend Memoist

    action :find

    def process(*)
      return unless link.present?
      return if model == link.story || !valid_link?

      add_blocked_story_links
      link.missing_story? ? add_link : merge_story
      RefreshStoryJob.perform_async(model.id)
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
    end

    def merge_story
      other_story = link.story
      merge_blocked_story_links(other_story.blocked_story_links)

      other_story.links.find_each do |similar_link|
        merge_blocked_story_links(similar_link.blocked_story_links)
        similar_link.update_attributes(story: model)
      end

      ::Story::Destroy.run(id: other_story.id)
    end

    def add_blocked_story_links
      ::BlockedStoryLink.where(story: model, link: link).destroy_all
      merge_blocked_story_links(link.blocked_story_links)
    end

    def merge_blocked_story_links(blocked_story_links)
      blocked_story_links.each do |blocked_link|
        next if model.link_ids.include?(blocked_link.link.id)
        next if model.blocked_link_ids.include?(blocked_link.link.id)
        model.blocked_story_links.create(link_id: blocked_link.link.id)
      end
      ::BlockedStoryLink::DestroyAll.run(blocked_story_links.map(&:id))
    end

    memoize :link
  end
end
