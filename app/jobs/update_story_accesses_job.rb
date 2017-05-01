class UpdateStoryAccessesJob
  include Sidekiq::Worker

  sidekiq_options queue: :update_story_accesses, retry: false

  def perform(link_id, date)
    Story::UpdateAccesses.run(link_id: link_id, date: date)
  end
end
