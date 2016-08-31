class Category
  class Contract < Reform::Form
    property :name
    property :namespace_ids

    validates :name, presence: true, unique: { case_sensitive: false }
  end
end
