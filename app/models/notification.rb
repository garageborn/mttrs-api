class Notification
  include ActiveModel::Model
  attr_accessor :title, :message, :data, :image

  def initialize(attributes = {})
    super(attributes)
    @data ||= {}
  end

  def to_json
    {
      app_id: app_id,
      big_picture: big_picture,
      contents: contents,
      data: data,
      headings: headings,
      included_segments: included_segments,
      ios_attachments: ios_attachments
    }
  end

  private

  def app_id
    ENV['ONESIGNAL_APP_ID']
  end

  def contents
    { en: message }
  end

  def headings
    { en: title }
  end

  def ios_attachments
    { id: image }
  end

  def big_picture
    image
  end

  def included_segments
    [Apartment::Tenant.current]
  end
end
