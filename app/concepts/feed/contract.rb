require 'reform/form/validation/unique_validator'

class Feed
  class Contract < Reform::Form
    include Reform::Form::ModelReflections

    property :publisher_id
    property :category_id
    property :url
    validates :publisher_id, :category_id, presence: true
    validates :url, presence: true, unique: { case_sensitive: false }

    def prepopulate!(options)
      self.publisher_id ||= options[:params][:publisher_id]
      self.category_id ||= options[:params][:category_id]
    end
  end
end
