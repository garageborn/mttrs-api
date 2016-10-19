module Utils
  class UrlFetcher
    RESCUE_FROM = [
      EOFError,
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EHOSTUNREACH,
      Errno::ENETUNREACH,
      Errno::EPIPE,
      HTTParty::RedirectionTooDeep,
      Net::HTTPFatalError,
      Net::HTTPRetriableError,
      Net::HTTPServerException,
      OpenSSL::SSL::SSLError,
      SocketError,
      Timeout::Error
    ].freeze

    def self.run(url)
      HTTParty.get(
        url,
        format: :plain,
        headers: { 'User-Agent' => Utils::UserAgent.sample },
        verify: false
      )
    rescue *RESCUE_FROM
    end
  end
end
