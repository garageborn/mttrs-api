class UrlDiscovery
  def self.run(url)
    head = HTTParty.head(url, headers: { 'User-Agent' => '' }, verify: false)
    url = head.request.last_uri.to_s if head.success?
  rescue HTTParty::Error
  ensure
    return Addressable::URI.parse(url).omit(:query, :fragment).to_s
  end
end
