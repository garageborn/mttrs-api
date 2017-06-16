class Link
  class Contract < Reform::Form
    property :category_id, virtual: true
    property :category_link
    property :description
    property :html
    property :image_source_url
    property :language
    property :published_at
    property :publisher_id
    property :story
    property :tag_ids
    property :title
    property :blocked_links

    collection :link_urls do
      property :url
    end

    validates :title, :publisher_id, :published_at, presence: true
    validates :language, inclusion: { in: Utils::Language::AVAILABLE_LANGUAGES }, allow_blank: true

    def prepopulate!(_options)
      link_urls << LinkUrl.new if link_urls.blank?
      self.category_id = category_link.try(:category_id) if category_id.blank?
    end
  end
end
