class CategoryLink
  class Contract < Reform::Form
    property :category_id
    property :link_id

    validates :category_id, :link_id, presence: true
  end
end
