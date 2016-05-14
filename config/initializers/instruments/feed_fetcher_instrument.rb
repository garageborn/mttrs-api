ActiveSupport::Notifications.subscribe('feed.created') do |_name, _start, _finish, _id, feed|
  FeedFetcherJob.perform_later(feed.id)
end
