class Publisher
  class Contract < Reform::Form
    property :name
    property :domain

    validates :name, presence: true, unique: { case_sensitive: false }
    validates :domain, presence: true
  end
end
