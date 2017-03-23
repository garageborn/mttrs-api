class Notification < ActiveRecord::Base
  include Concerns::Filterable

  belongs_to :notificable, polymorphic: true

  scope :recent, -> { order(created_at: :desc) }

  def onesignal_url
    return if onesignal_id.blank?
    "https://onesignal.com/apps/#{ app_id }/notifications/#{ onesignal_id }"
  end

  def to_query(data = {})
    {
      app_id: app_id,
      big_picture: big_picture,
      contents: contents,
      data: data.merge(tenant: Apartment::Tenant.current),
      headings: headings,
      included_segments: included_segments,
      ios_attachments: ios_attachments
    }
  end

  private

  def app_id
    ENV['ONESIGNAL_APP_ID']
  end

  def big_picture
    image_url
  end

  def contents
    { en: message }
  end

  def headings
    { en: title }
  end

  def included_segments
    [Apartment::Tenant.current]
  end

  def ios_attachments
    { id: image_url }
  end
end
