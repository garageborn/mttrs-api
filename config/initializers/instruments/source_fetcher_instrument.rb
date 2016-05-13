ActiveSupport::Notifications.subscribe('source.created') do |_name, _start, _finish, _id, source|
  SourceFetcherJob.perform_later(source.id)
end
