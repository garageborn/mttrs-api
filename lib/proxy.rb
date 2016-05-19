module Proxy
  autoload :GimmeProxy, './lib/proxy/gimme_proxy'

  class << self
    def request(url, options = {}, method: :get, max_tries: 3)
      with_retries(max_tries: max_tries) do
        if proxy = sources.sample.current
          options[:http_proxyaddr] = proxy[:host]
          options[:http_proxyport] = proxy[:port]
        end
        HTTParty.send(method, url, options)
      end
    end

    def sources
      [GimmeProxy.instance]
    end
  end
end
