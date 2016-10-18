class StoryBuilderJob
  include Sidekiq::Worker

  sidekiq_options queue: :story_builder

  def perform(link_id)
    Story::Builder.run(link_id: link_id)
  end
end
