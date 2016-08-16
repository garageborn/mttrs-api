class SocialCounterFetcherJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :social_counter
  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || social.blank?

    SocialCounterUpdateJob.new.perform(link.id, social.to_h)
  end

  private

  def link
    Utils::Thread.with_connection do
      Link.find_by_id(link_id)
    end
  end

  def social
    Social.count(link.url)
  end

  memoize :link, :social
end
