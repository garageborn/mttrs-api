class BuzzsumoEntry
  extend Memoist

  MIN_TOTAL_SOCIAL = 10.freeze
  ATTRIBUTES = %i[
    facebook
    google_plus
    image_source_url
    language
    linkedin
    pinterest
    published_at
    publisher_id
    title
    twitter
    url
  ].freeze

  attr_accessor :entry, :publisher_id, :image_source_url, :language, :published_at, :title, :url,
                :facebook, :google_plus, :linkedin, :pinterest, :twitter, :total

  def initialize(entry)
    @entry = entry.to_h.with_indifferent_access
    @publisher_id = entry[:publisher_id]

    @image_source_url = entry[:thumbnail]
    @language = entry[:language]
    @published_at = entry[:published_date].to_i
    @title  = entry[:title]
    @url = entry[:url]

    @facebook = entry[:total_facebook_shares].to_i
    @google_plus = entry[:google_plus_shares].to_i
    @linkedin = entry[:linkedin_shares].to_i
    @pinterest = entry[:pinterest_shares].to_i
    @twitter = entry[:twitter_shares].to_i
    @total = facebook + google_plus + twitter + pinterest
  end

  def valid?
    publisher.present? && !blocked_url? && match_min_social?
  end

  def to_h
    ATTRIBUTES.map { |attr| [attr, send(attr)] }.to_h
  end

  def publisher
    Publisher.find_by(id: publisher_id)
  end

  private

  def blocked_url?
    publisher.blocked_urls.match?(entry[:url])
  end

  def match_min_social?
    total >= MIN_TOTAL_SOCIAL
  end

  memoize :publisher
end
