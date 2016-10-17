class CategoryMatcher
  class Contract < Reform::Form
    feature Coercion

    property :publisher_id
    property :category_id
    property :url_matcher
    property :try_out, virtual: true, type: Types::Form::Bool

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
