class StoryBuilderJob
  include Sidekiq::Worker

  sidekiq_options queue: :story_builder, max_performs: {
    count: 2,
    key: proc { |link_id| link_id }
  }

  def perform(link_id)
    Story::Builder.run(link_id: link_id)
  end
end
