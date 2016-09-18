class CategoryFeed
  class Contract < Reform::Form
    property :category_id
    property :feed_id

    validates :category_id, :feed_id, presence: true
  end
end
