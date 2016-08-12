class Proxy
  TIMEOUT = 60
  PROXY_URL = ENV['PROXY_INTERNAL_URL'] || ENV['PROXY_URL'] || 'http://proxy.mtt.rs'

  def self.request(url, options: {}, verb: :get)
    params = options.to_h.merge(url: url)
    HTTParty.send(verb, PROXY_URL, query: params, timeout: TIMEOUT )
  end
end
