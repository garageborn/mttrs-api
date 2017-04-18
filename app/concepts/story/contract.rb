class Story
  class Contract < Reform::Form
    property :category_id
    property :headline
    property :summary
    property :links
    property :blocked_links
    property :published_at
    property :main_link
    property :link_ids
    property :added_links, virtual: true
    property :removed_links, virtual: true
    property :main_image_source_url, writeable: false
  end
end
