class RefreshStoryJob
  include Sidekiq::Worker

  def perform(story_id)
    Story::Refresh.run(id: story_id)
  end
end
