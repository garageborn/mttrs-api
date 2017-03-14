class Story
  class Contract < Reform::Form
    property :headline
    property :summary
    property :links
    property :published_at
    property :main_link
    property :link_ids
    property :added_links, virtual: true
    property :removed_links, virtual: true
  end
end
