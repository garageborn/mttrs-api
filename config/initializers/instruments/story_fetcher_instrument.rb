ActiveSupport::Notifications.subscribe('story.created') do |_name, _start, _finish, _id, story|
  StoryFetcherJob.perform_later(story.id)
end
