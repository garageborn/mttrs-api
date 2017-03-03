class StoryMergerJob
  include Sidekiq::Worker

  def perform(id, destination_id)
    Story::Merger.run(id: id, destination_id: destination_id)
  end
end
