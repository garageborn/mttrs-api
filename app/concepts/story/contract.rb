class Story
  class Contract < Reform::Form
    property :headline
    property :summary
    property :links
    property :published_at
  end
end
