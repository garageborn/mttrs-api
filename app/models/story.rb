class Story < ActiveRecord::Base
  include Concerns::Filterable
  include Concerns::ParseDate

  has_many :categories, -> { distinct }, through: :links
  has_many :links, inverse_of: :story, dependent: :nullify,
           after_remove: :refresh!, after_add: :refresh!
  has_many :publishers, -> { distinct }, through: :links
  has_one :main_link, -> { where(main: true) }, class_name: 'Link'

  delegate :uri, :url, :title, :image_source_url, :published_at, to: :main_link

  scope :category_slug, -> (slug) { joins(:categories).where(categories: { slug: slug }) }
  scope :last_month, -> { published_since(1.month.ago) }
  scope :last_week, -> { published_since(1.week.ago) }
  scope :order_by_links_count, lambda {
    joins(:links).group('stories.id').order('count(links.id) desc')
  }
  scope :popular, -> { order(total_social: :desc) }
  scope :published_at, lambda { |date|
    date = parse_date(date)
    published_between(date.at_beginning_of_day, date.end_of_day)
  }
  scope :published_between, lambda { |start_at, end_at|
    joins(:main_link).where(links: { published_at: parse_date(start_at)..parse_date(end_at) })
  }
  scope :published_since, lambda { |date|
    joins(:main_link).where('links.published_at >= ?', parse_date(date))
  }
  scope :publisher_slug, -> (slug) { joins(:publishers).where(publishers: { slug: slug }) }
  scope :recent, -> { joins(:main_link).order('links.published_at desc') }

  def refresh!(_link = nil)
    return destroy if links.blank?
    refresh_total_social
    refresh_main_link
  end

  private

  def refresh_total_social
    update_attributes(total_social: links.sum(:total_social).to_i)
  end

  def refresh_main_link
    main_link = links.popular.first
    main_link.update_column(:main, true)
    links.where.not(id: main_link).update_all(main: false)
  end
end
