class AmpLink
  class Contract < Reform::Form
    property :link_id
    property :status
    property :url

    validates :link_id, presence: true
  end
end
