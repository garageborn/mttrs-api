class Story < ActiveRecord::Base
  include Concerns::Filterable

  has_many :links, inverse_of: :story, dependent: :nullify
  has_one :main_link, -> { order(total_social: :desc) }, class_name: 'Link'

  delegate :uri, :url, :title, :image_source_url, :published_at, to: :main_link

  scope :popular, -> { order(total_social: :desc) }
  scope :recent, -> { joins(:main_link).order('links.published_at desc') }

  def refresh!
    update_attributes(
      total_social: links.sum(:total_social).to_i
    )
  end
end
