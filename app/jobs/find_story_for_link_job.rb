class FindStoryForLinkJob < ActiveJob::Base
  extend Memoist
  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link.blank?
  end

  private

  def link
    Link.find_by_id(link_id)
  end

  memoize :link
end
