class Link
  class Contract < Reform::Form
    property :content
    property :description
    property :html
    property :image_source_url
    property :language
    property :published_at
    property :publisher_id
    property :similar, writeable: false
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
    end
  end
end
