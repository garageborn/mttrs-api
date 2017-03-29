class TagMatcher
  class Contract < Reform::Form
    feature Coercion

    property :tag_id
    property :publisher_id
    property :url_matcher
    property :html_matcher_selector
    property :html_matcher
    property :try_out, virtual: true, type: Types::Form::Bool

    validates :publisher_id, :tag_id, presence: true
  end
end
