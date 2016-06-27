class Story < ActiveRecord::Base
  include Concerns::Filterable
  include Concerns::ParseDate

  has_many :categories, -> { distinct }, through: :links
  has_many :links, inverse_of: :story, dependent: :nullify
  has_many :publishers, -> { distinct }, through: :links
  has_one :main_link, -> { order(total_social: :desc) }, class_name: 'Link'

  delegate :uri, :url, :title, :image_source_url, :published_at, to: :main_link

  scope :category_slug, -> (slug) { joins(:categories).where(categories: { slug: slug }) }
  scope :last_month, -> { published_since(1.month.ago) }
  scope :last_week, -> { published_since(1.week.ago) }
  scope :popular, -> { order(total_social: :desc) }
  scope :published_at, lambda { |date|
    date = parse_date(date)
    published_between(date.at_beginning_of_day, date.end_of_day)
  }
  scope :published_between, lambda { |start_at, end_at|
    joins(:links).where(links: { published_at: parse_date(start_at)..parse_date(end_at) })
  }
  scope :published_since, lambda { |date|
    joins(:links).where('links.published_at >= ?', parse_date(date))
  }
  scope :publisher_slug, -> (slug) { joins(:publishers).where(publishers: { slug: slug }) }
  scope :recent, -> { joins(:main_link).order('links.published_at desc') }

  def refresh!
    update_attributes(
      total_social: links.sum(:total_social).to_i
    )
  end
end
