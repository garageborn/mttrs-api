class Link
  class Contract < Reform::Form
    property :description
    property :image_source_url
    property :language
    property :published_at
    property :publisher_id
    property :category_ids
    property :link_url_ids
    property :title
    property :urls

    validates :title, :publisher_id, :published_at, presence: true
    validates :language, inclusion: { in: Utils::Language::EXISTING_LANGUAGES }, allow_blank: true
  end
end
