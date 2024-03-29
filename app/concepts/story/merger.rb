class Story
  class Merger < Operation
    extend Memoist

    action :find

    def process(*)
      return unless destination.present?
      return if model == destination || !match_category?

      model.links.find_each do |link|
        link.with_lock { link.update_attributes(story: destination) }
      end
      Story::Destroy.run(id: model.id)
      RefreshStoryJob.perform_async(destination.id)
    end

    private

    def destination
      ::Story.find_by(id: @params[:destination_id])
    end

    def match_category?
      model.category_id == destination.category_id
    end

    memoize :destination
  end
end
