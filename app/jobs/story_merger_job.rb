class StoryMergerJob
  include Sidekiq::Worker

  sidekiq_options queue: :story_merger

  def perform(id, destination_id)
    Story::Merger.run(id: id, destination_id: destination_id)
  end
end
