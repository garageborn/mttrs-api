class PublisherSuggestion
  class Contract < Reform::Form
    property :name
    property :count
    validates :name, presence: true, unique: { case_sensitive: false }
  end
end
