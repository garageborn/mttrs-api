class Notification
  class Contract < Reform::Form
    property :title
    property :message
    property :image

    validates :title, :message, :image, presence: true
  end
end
