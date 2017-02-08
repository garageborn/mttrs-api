module Utils
  class UrlDiscovery
    def self.run(source_url)
      new(source_url).urls
    end

    attr_accessor :urls

    def initialize(source_url)
      @urls = []
      add_url(source_url)
      perform
    end

    private

    def perform
      head = HTTParty.head(urls.last, headers: { 'User-Agent' => '' }, verify: false)
      add_url(head.request.last_uri.to_s) if head.success?
    rescue *Utils::NetworkErrors::RESCUE_FROM
    end

    def add_url(url)
      @urls = (@urls + parse_url(url)).flatten.compact.uniq
    end

    def parse_url(url)
      uri = build_uri(url)
      [uri.to_s, uri.omit(:query, :fragment).to_s]
    end

    def build_uri(url)
      Addressable::URI.parse(url.force_encoding('UTF-8')).normalize
    rescue Encoding::UndefinedConversionError
      Addressable::URI.parse(url).normalize
    end
  end
end
