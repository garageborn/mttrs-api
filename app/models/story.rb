class Story < ApplicationRecord
  include Concerns::Filterable
  include Concerns::ParseDate
  include Tenant::Concerns::Model

  has_many :categories, -> { distinct }, through: :links
  has_many :links, inverse_of: :story, dependent: :nullify, after_remove: :refresh!, after_add: :refresh!
  has_many :namespaces, -> { distinct }, through: :links
  has_many :publishers, -> { distinct }, through: :links
  has_one :main_link, -> { where(main: true) }, class_name: 'Link'

  delegate :uri, :url, :title, :image_source_url, :published_at, to: :main_link

  scope :category_slug, lambda { |slug|
    joins(:categories).group(:id).where(categories: { slug: slug })
  }
  scope :last_month, -> { published_since(1.month.ago) }
  scope :last_week, -> { published_since(1.week.ago) }
  scope :namespace, lambda { |id|
    p '---------story namespace', id
    all
    # joins(links: :namespaces).where(namespaces: { id: id })
    # joins(links: :links_namespaces).where(links: { links_namespaces: { namespace_id: id } })
  }
  scope :order_by_links_count, lambda {
    joins(:links).group(:id).order('count(links.id) desc')
  }
  scope :popular, -> { order(total_social: :desc) }
  scope :published_at, lambda { |date|
    date = parse_date(date)
    published_between(date.at_beginning_of_day, date.end_of_day)
  }
  scope :published_between, lambda { |start_at, end_at|
    joins(:main_link).where(
      links: { main: true, published_at: parse_date(start_at)..parse_date(end_at) }
    )
  }
  scope :published_since, lambda { |date|
    joins(:main_link).where(
      links: { main: true, published_at: parse_date(date)..Float::INFINITY }
    )
  }
  scope :publisher_slug, lambda { |slug|
    joins(:publishers).group(:id).where(publishers: { slug: slug })
  }
  scope :recent, lambda {
    joins(:main_link).where(links: { main: true }).order('links.published_at desc')
  }
  scope :today, -> { published_at(Time.zone.now) }
  scope :yesterday, -> { published_at(1.day.ago) }

  # tenant namespace: :namespace

  def refresh!(_link = nil)
    return destroy if links.blank?
    refresh_total_social
    refresh_main_link
  end

  def total_facebook
    links.map { |link| link.social_counter.try(:facebook).to_i }.sum
  end

  def total_linkedin
    links.map { |link| link.social_counter.try(:linkedin).to_i }.sum
  end

  def total_twitter
    links.map { |link| link.social_counter.try(:twitter).to_i }.sum
  end

  def total_pinterest
    links.map { |link| link.social_counter.try(:pinterest).to_i }.sum
  end

  def total_google_plus
    links.map { |link| link.social_counter.try(:google_plus).to_i }.sum
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
