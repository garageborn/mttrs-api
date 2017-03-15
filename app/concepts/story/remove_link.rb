class Story
  class RemoveLink < Operation
    extend Memoist

    action :find

    def process(*)
      return unless link.present?

      link.update_attributes(story: nil)
      ::BlockedStoryLink.where(story: model, link: link).first_or_create

      StoryBuilderJob.perform_async(link.id)
      RefreshStoryJob.perform_async(model.id)
    end

    private

    def link
      ::Link.find_by(id: @params[:link_id])
    end

    memoize :link
  end
end
