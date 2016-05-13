ActiveSupport::Notifications.subscribe('link.created') do |_name, _start, _finish, _id, link|
  LinkFetcherJob.perform_later(link.id)
end
