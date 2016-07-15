class LinkCategorizerJob < ActiveJob::Base
  extend Memoist
  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link.blank?

    categories.each do |category|
      next if link.categories.include?(category)
      link.categories << category
    end
  end

  private

  def link
    Link.find_by_id(link_id)
  end

  def categories
    feeds_categories = link.feeds.map(&:category).to_a
    matchers_categories = LinkCategorizer.run(link).to_a
    [feeds_categories + matchers_categories].flatten.compact.uniq
  end

  memoize :link, :categories
end