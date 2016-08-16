class SocialCounterFetcherJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :social_counter
  attr_reader :link_id

  def perform(link_id)
    puts "\n perform #{ link_id }"
    sleep 20

    # @link_id = link_id
    # return if link.blank? || social.blank?
    # Rails.logger.info social.to_h

    # SocialCounterUpdateJob.new.perform(link.id, social.to_h)
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
