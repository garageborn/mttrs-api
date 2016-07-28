require 'reform/form/validation/unique_validator'

class Link
  class Contract < Reform::Form
    include Reform::Form::ModelReflections

    property :category_ids
    property :language
    property :published_at
    property :publisher_id
    property :source_url
    property :title
    property :url

    validates :title, :publisher_id, :published_at, presence: true
    validates :source_url, :url, presence: true, unique: { case_sensitive: false }
    validates :language, inclusion: { in: Utils::Language::EXISTING_LANGUAGES }, allow_blank: true
  end
end
