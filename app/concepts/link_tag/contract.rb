class LinkTag
  class Contract < Reform::Form
    property :link_id
    property :tag_id

    validates :link_id, :tag_id, presence: true
  end
end
