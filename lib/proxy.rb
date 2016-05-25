module Proxy
  autoload :GimmeProxy, './lib/proxy/gimme_proxy'
  RESCUE_FROM = [Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError, Timeout::Error].freeze
  DEFAULT_TIMEOUT = 10
  MAX_RETRIES = 7

  class << self
    attr_accessor :current_source, :current_proxy

    def request(url, options = {}, method: :get, max_tries: MAX_RETRIES)
      options[:timeout] ||= DEFAULT_TIMEOUT

      current_source, current_proxy = get_proxy

      handler = proc do
        current_source.fail(current_proxy)
        current_source, current_proxy = get_proxy
      end

      with_retries(max_tries: max_tries, handler: handler, rescue: RESCUE_FROM) do |attempt|
        if attempt == MAX_RETRIES || current_proxy.blank?
          options.delete(:http_proxyaddr)
          options.delete(:http_proxyport)
        else
          options[:http_proxyaddr] = current_proxy[:host]
          options[:http_proxyport] = current_proxy[:port]
        end

        request = HTTParty.send(method, url, options)
        raise Errno::ECONNREFUSED unless request.success?
        request
      end
    end

    def get_proxy
      current_source = sources.sample
      current_proxy = current_source.sample
      [current_source, current_proxy]
    end

    def sources
      [GimmeProxy.instance]
    end
  end
end