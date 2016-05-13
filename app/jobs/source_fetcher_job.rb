class SourceFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(source_id)
    @source_id = source_id
    return if source.blank?

    feed.items.each do |item|
      link = Link.where(url: item.link).first_or_create
      link.sources << source unless link.sources.include?(source)
    end
  end

  private

  def source
    Source.find_by_id(@source_id)
  end

  def feed
    RSS::Parser.parse(open(source.rss))
  end

  memoize :source, :feed
end
