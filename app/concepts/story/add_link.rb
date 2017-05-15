class Story
  class AddLink < Operation
    extend Memoist

    action :find

    def process(*)
      return if link.blank?
      return if model == link.story || !valid_link?

      link.missing_story? ? add_link(link) : merge_story
      RefreshStoryJob.perform_async(model.id)
    end

    private

    def link
      ::Link.find_by(id: @params[:link_id])
    end

    def valid_link?
      link.belongs_to_current_tenant? && link.category == model.category
    end

    def merge_story
      other_story = link.story
      merge_blocked_links(other_story)
      other_story.links.find_each { |similar_link| add_link(similar_link) }
      ::Story::Destroy.run(id: other_story.id)
    end

    def merge_blocked_links(story)
      blocked_link_ids = model.link_ids + model.blocked_link_ids
      story.blocked_story_links.where.not(link_id: blocked_link_ids).each do |blocked_story_link|
        model.blocked_story_links.create(link: blocked_story_link.link)
        blocked_story_link.destroy
      end
    end

    def add_link(link)
      link.blocked_story_links.where(link_id: model.link_ids + model.blocked_link_ids).destroy_all
      model.blocked_story_links.where(link_id: link.id).destroy_all
      link.with_lock do
        fixed = model.story_links.fixed.blank? && link.story&.story_links&.fixed&.link_id == link.id
        model.story_links.where(link: link).first_or_create.update_attributes(fixed: fixed)
      end
    end

    memoize :link
  end
end
