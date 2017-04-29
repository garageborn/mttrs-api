class Tag
  class Contract < Reform::Form
    property :category_id
    property :name
    property :order
    property :slug

    validates :category_id, :name, presence: true
  end
end
