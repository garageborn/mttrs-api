class LinkFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(link_id)
    @link_id = link_id
    return if link.blank?

    link.fetching!
    if link.update_attributes(social: social)
      link.ready!
    else
      link.error!
    end
  end

  private

  def link
    Link.find_by_id(@link_id)
  end

  def social
    SocialShare.count(link.url).try(:to_h) || {}
  end

  memoize :link, :social
end
