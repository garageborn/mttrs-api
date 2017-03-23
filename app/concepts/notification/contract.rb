class Notification
  class Contract < Reform::Form
    property :notificable_type
    property :notificable_id
    property :title
    property :message
    property :image_url
    property :onesignal_id
    property :onesignal_url, virtual: true

    validates :title, :message, presence: true

    def prepopulate!(options)
      notification_params = options[:params][:notification]
      return if notification_params.blank?

      self.notificable_type ||= notification_params[:notificable_type]
      self.notificable_id ||= notification_params[:notificable_id]
      self.title ||= notification_params[:title]
      self.message ||= notification_params[:message]
      self.image_url ||= notification_params[:image_url]
    end
  end
end
