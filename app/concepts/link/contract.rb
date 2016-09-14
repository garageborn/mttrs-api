class Link
  class Contract < Reform::Form
    property :category_ids
    property :language
    property :namespace_ids
    property :published_at
    property :publisher_id
    property :source_url
    property :title
    property :url

    validates :title, :publisher_id, :published_at, presence: true
    validates :source_url, :url, presence: true, unique: { case_sensitive: false }
    validates :language, inclusion: { in: Utils::Language::EXISTING_LANGUAGES }, allow_blank: true
    # validate :validate_unique_link

    # def validate_unique_link
    #   return if publisher.blank?
    #   other_link = publisher.links.where(title: title).where.not(id: id).first
    #   return if other_link.blank?
    #   errors.add(:url, :invalid) if other_link.uri.path == uri.path
    # end
  end
end
