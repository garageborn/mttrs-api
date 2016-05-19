module Proxy
  class GimmeProxy
    include Singleton
    extend Memoist

    GET_PROXY_URL = 'http://gimmeproxy.com/api/getProxy?supportsHttps=true'.freeze
    DEFAULT_RATE_LIMIT = 10

    attr_accessor :last_request

    def current
      sample_proxy
    end

    def fail(proxy)
      proxies.delete(proxy)
    end

    def proxies
      []
    end

    private

    def sample_proxy
      request_new_proxy(wait: true) if proxies.blank?
      fill_proxies
      proxies.sample
    end

    def request_new_proxy(wait: false)
      new_proxy_proc = proc do
        current_request = fetch_proxy!
        add_proxy(
          host: current_request.parsed_response['ip'],
          port: current_request.parsed_response['port']
        )
        @last_request = current_request
      end

      return new_proxy_proc.call if wait == true
      pool.process { new_proxy_proc.call }
    end

    def fetch_proxy!
      with_retries(max_tries: 3) do
        sleep next_rate_limit_window if at_rate_limit?

        request = HTTParty.get(GET_PROXY_URL)
        fail unless request.success?
        return request
      end
    end

    def fill_proxies
      return if proxies.size >= rate_limit
      return unless pool.idle?
      (rate_limit - proxies.size).times { request_new_proxy(wait: false) }
    end

    def add_proxy(new_proxy)
      return if new_proxy[:host].blank? || new_proxy[:port].blank?
      proxies.push(new_proxy) unless proxies.include?(new_proxy)
    end

    def at_rate_limit?
      return false if last_request.blank?
      last_request.code == 429
    end

    def rate_limit
      return DEFAULT_RATE_LIMIT if last_request.blank?
      last_request.headers['x-ratelimit-limit'].to_i || DEFAULT_RATE_LIMIT
    end

    def rate_limit_remaining
      return DEFAULT_RATE_LIMIT if last_request.blank?
      last_request.headers['x-ratelimit-remaining'].to_i
    end

    def next_rate_limit_window
      1.minute.from_now
    end

    def pool
      Thread.abort_on_exception = true
      Thread.pool(rate_limit)
    end

    memoize :proxies, :pool
  end
end
