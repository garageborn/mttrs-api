class AttributeMatcher
  class Contract < Reform::Form
    include Concerns::NestedForm

    property :matcher
    property :name
    validates :matcher, presence: true
    validates :name, presence: true, inclusion: {
      in: %w(description image_source_url language published_at title)
    }
  end
end
