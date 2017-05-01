class AmpFetcherJob
  extend Memoist
  include Sidekiq::Worker

  sidekiq_options queue: :amp_fetcher, retry: false

  # https://developers.google.com/amp/cache/reference/limits
  LIMIT_WINDOW = 100
  REQUESTS_PER_WINDOW = 10
  URLS_PER_REQUEST = 50

  def perform
    return if links.blank?
    mark_fetching_links
    update_success_links
    update_error_links
  ensure
    mark_pending_links
  end

  private

  def links
    ::AmpLink.recent.pending.limit(URLS_PER_REQUEST).map(&:link)
  end

  def urls
    links.map(&:url)
  end

  def mark_fetching_links
    links.each do |link|
      link.amp_link.with_lock { link.amp_link.fetching! }
    end
  end

  def mark_pending_links
    links.each do |link|
      next unless link.amp_link.fetching?
      link.amp_link.with_lock { link.amp_link.pending! }
    end
  end

  def amp_response
    ::Amp.fetch(urls)
  end

  def update_success_links
    success_links.each { |link| update_success_link(link) }
  end

  def update_success_link(link)
    amp_url = amp_response.amp_urls.detect { |r| r.original_url == link.url }
    url = amp_url.cdn_amp_url || amp_url.amp_url
    return if url.blank?
    link.amp_link.with_lock { link.amp_link.update_attributes(status: :success, url: url) }
  end

  def update_error_links
    error_links.each do |link|
      link.amp_link.with_lock { link.amp_link.error! }
    end
  end

  def success_links
    return [] if amp_response.amp_urls.blank?
    urls = amp_response.amp_urls.map(&:original_url)
    links.select { |link| urls.include?(link.url) }
  end

  def error_links
    return [] if amp_response.url_errors.blank?
    urls = amp_response.url_errors.map(&:original_url)
    links.select { |link| urls.include?(link.url) }
  end

  memoize :links, :urls, :amp_response, :success_links, :error_links
end
