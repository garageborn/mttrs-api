class Story
  class Merger < Operation
    extend Memoist

    action :find

    def process(*)
      return unless destination.present?
      return if model == destination

      model.links.find_each do |link|
        link.update_attributes(story: destination)
      end
      Story::Destroy.run(id: model.id)
      Story::Refresh.run(id: destination.id)
    end

    private

    def destination
      ::Story.find_by(id: @params[:destination_id])
    end

    memoize :destination
  end
end
