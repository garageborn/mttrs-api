class Story
  class Contract < Reform::Form
    property :category_id
    property :headline
    property :summary
    property :summarized_at
    property :links
    property :blocked_links
    property :published_at
    property :main_link
    property :link_ids
    property :story_links
    property :added_links, virtual: true
    property :removed_links, virtual: true
    property :fixed_link_id, virtual: true
    property :main_image_source_url, writeable: false

    def prepopulate!(_options)
      self.fixed_link_id = story_links.fixed.try(:link_id) if fixed_link_id.blank?
    end
  end
end
