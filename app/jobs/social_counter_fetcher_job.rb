class SocialCounterFetcherJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :social_counter
  attr_reader :link_id

  def perform(link_id)
    return if Rails.env.development?

    @link_id = link_id
    return if link.blank? || counters.blank?

    SocialCounter::UpdateCounters.run(link: link, counters: counters)
  end

  private

  def link
    Utils::Thread.with_connection do
      Link.find_by_id(link_id)
    end
  end

  def counters
    Social.count(link.uri)
  end

  memoize :link, :counters
end
