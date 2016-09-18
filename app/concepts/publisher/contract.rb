class Publisher
  class Contract < Reform::Form
    property :name
    property :slug
    property :domain

    validates :name, presence: true, unique: { case_sensitive: false }
    validates :slug, presence: true, unique: { case_sensitive: false }
    validates :domain, presence: true, unique: { case_sensitive: false }
  end
end
