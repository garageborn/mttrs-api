module Utils
  class NetworkErrors
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
  end
end
