class StoryBuilderJob
  include Sidekiq::Worker

  def perform(link_id)
    Story::Builder.run(link_id: link_id)
  end
end
