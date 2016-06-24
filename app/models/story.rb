class Story < ActiveRecord::Base
  include Concerns::Filterable

  has_many :links, inverse_of: :story, dependent: :destroy
  has_one :main_link, -> { order(total_social: :desc) }, class_name: 'Link'

  delegate :url, :title, :image_source_url, :published_at, to: :main_link
end
