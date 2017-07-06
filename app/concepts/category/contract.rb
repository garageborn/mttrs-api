class Category
  class Contract < Reform::Form
    property :color
    property :name
    property :order
    property :similar_min_score

    validates :color, presence: true
    validates :name, presence: true, unique: { case_sensitive: false }
  end
end
