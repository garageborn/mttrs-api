class AttributeMatcher < ApplicationRecord
  belongs_to :publisher

  scope :description, -> { where(name: :description) }
  scope :image_source_url, -> { where(name: :image_source_url) }
  scope :language, -> { where(name: :language) }
  scope :published_at, -> { where(name: :published_at) }
  scope :title, -> { where(name: :title) }
end
