class TagMatcher
  class Contract < Reform::Form
    property :tag_id
    property :url_matcher
    property :html_matcher_selector
    property :html_matcher

    validates :tag_id, presence: true
  end
end
