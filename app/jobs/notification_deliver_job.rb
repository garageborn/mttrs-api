class NotificationDeliverJob
  include Sidekiq::Worker

  sidekiq_options queue: :notification_deliver, retry: false

  def perform(notification_id)
    Notification::Deliver.run(id: notification_id)
  end
end
