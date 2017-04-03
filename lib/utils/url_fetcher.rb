module Utils
  class UrlFetcher
    BLOCKED_STATUS_CODES = [
      401, # Unauthorized (RFC 7235)
      403, # Forbidden
      429, # Too Many Requests (RFC 6585)
      509, # Bandwidth Limit Exceeded
    ].freeze

    class << self
      def run(url)
        request = local_request(url)
        return if request.blank?
        return request if request.success?
        return proxy_request(url) if BLOCKED_STATUS_CODES.include?(request.code)
        request
      end

      def local_request(url)
        Typhoeus.get(
          url,
          followlocation: true,
          headers: {
            'User-Agent' => Utils::UserAgent.sample,
            # 'Content-Type' => 'text/html; charset=utf-8' # temp disable
          },
          ssl_verifypeer: false
        )
      rescue *Utils::NetworkErrors::RESCUE_FROM
      end

      def proxy_request(url)
        ::Proxy.request(url)
      end
    end
  end
end
