class StoryBuilderJob
  include Sidekiq::Worker

  sidekiq_options queue: :story_builder, retry: false, unique: :until_executed

  def perform(link_id)
    Story::Builder.run(link_id: link_id)
  end
end
