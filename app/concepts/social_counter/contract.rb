class SocialCounter
  class Contract < Reform::Form
    property :link_id
    property :parent_id
    property :facebook
    property :linkedin
    property :twitter
    property :pinterest
    property :google_plus
    property :total

    validates :link_id, presence: true
    validates :parent_id, unique: true, allow_blank: true
    validates :facebook, :linkedin, :twitter, :pinterest, :google_plus, :total,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
end
