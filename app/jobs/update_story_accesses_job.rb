class UpdateStoryAccessesJob
  include Sidekiq::Worker

  def perform(link_id, date)
    Story::UpdateAccesses.run(link_id: link_id, date: date)
  end
end
