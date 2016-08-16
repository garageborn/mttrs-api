class SocialCounterUpdateJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :link_id, :counters

  def perform(link_id, counters)
    @link_id = link_id
    @counters = counters.with_indifferent_access
    return if link.blank? || counters.blank?

    update
  end

  private

  def link
    Link.find_by_id(link_id)
  end

  def social_counter
    return link.social_counters.build if last_social_counter.blank?
    link.social_counters.build(parent: last_social_counter).tap do |social_counter|
      SocialCounter::PROVIDERS.each do |provider|
        social_counter[provider] = last_social_counter.read_attribute(provider)
      end
    end
  end

  def last_social_counter
    link.social_counter
  end

  def update
    counters.each { |provider, count| update_counter(provider, count) }
    social_counter.save if social_counter.increased?
  end

  def update_counter(provider, value)
    value = value.to_i
    provider = provider.to_sym
    return if value.blank?
    return if social_counter.read_attribute(provider) > value
    social_counter[provider] = value
  end

  memoize :link, :social_counter, :last_social_counter
end
