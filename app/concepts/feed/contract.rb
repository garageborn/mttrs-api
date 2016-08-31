class Feed
  class Contract < Reform::Form
    property :category_id
    property :language
    property :namespace_ids
    property :publisher_id
    property :url

    validates :publisher_id, :category_id, presence: true
    validates :url, presence: true, unique: { case_sensitive: false }
    validates :language, presence: true, inclusion: { in: Utils::Language::EXISTING_LANGUAGES }

    def prepopulate!(options)
      self.publisher_id ||= options[:params][:publisher_id]
      self.category_id ||= options[:params][:category_id]
    end
  end
end
