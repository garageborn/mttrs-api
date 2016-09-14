module Utils
  class UrlDiscovery
    def self.run(source_url)
      urls = [parse_url(source_url)]
      begin
        head = HTTParty.head(source_url, headers: { 'User-Agent' => '' }, verify: false)
        urls.push(parse_url(head.request.last_uri.to_s)) if head.success?
      rescue HTTParty::Error
      end
      urls.flatten.compact.uniq
    end

    def self.parse_url(url)
      [url, Addressable::URI.parse(url).omit(:query, :fragment).to_s]
    end
  end
end
