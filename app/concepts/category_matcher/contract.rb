class CategoryMatcher
  class Contract < Reform::Form
    feature Coercion

    property :category_id
    property :publisher_id
    property :order
    property :try_out, virtual: true, type: Types::Form::Bool
    property :url_matcher
    property :html_matcher
    property :html_matcher_selector

    validates :publisher_id, :category_id, presence: true
    validates :url_matcher,
              unique: { case_sensitive: false, scope: :publisher_id },
              allow_blank: true

    def prepopulate!(options)
      self.publisher_id ||= options[:params][:publisher_id]
      self.category_id ||= options[:params][:category_id]
    end
  end
end
