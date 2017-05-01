class RefreshStoryJob
  include Sidekiq::Worker

  sidekiq_options queue: :refresh_story, retry: false

  def perform(story_id)
    Story::Refresh.run(id: story_id)
  end
end
