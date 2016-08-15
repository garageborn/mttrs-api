class SocialCounterFetcherJob < ActiveJob::Base
  extend Memoist
  attr_reader :link_id

  queue_as :social_counter

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || social.blank?
    Rails.logger.info social.to_h

    # SocialCounterUpdateJob.perform_now(link.id, social.to_h)
  end

  private

  def link
    Link.find_by_id(link_id)
  end

  def social
    Social.count(link.url)
  end

  memoize :link, :social
end
