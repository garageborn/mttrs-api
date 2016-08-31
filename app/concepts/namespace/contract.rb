class Namespace
  class Contract < Reform::Form
    property :slug
    property :category_ids
    property :feed_ids

    validates :slug, presence: true, unique: { case_sensitive: false }
  end
end
