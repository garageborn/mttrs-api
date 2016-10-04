class Feed
  class Contract < Reform::Form
    property :language
    property :publisher_id
    property :category_ids
    property :url

    validates :publisher_id, presence: true
    validates :url, presence: true, unique: { case_sensitive: false }
    validates :language, presence: true, inclusion: { in: Utils::Language::EXISTING_LANGUAGES }

    def prepopulate!(options)
      self.publisher_id ||= options[:params][:publisher_id]
    end
  end
end
