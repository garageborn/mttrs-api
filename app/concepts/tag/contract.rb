class Tag
  class Contract < Reform::Form
    property :category_id
    property :name
    property :order

    validates :category_id, :name, presence: true
  end
end
