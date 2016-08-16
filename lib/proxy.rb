class Proxy
  TIMEOUT = 60
  PROXY_URL = ENV['PROXY_URL'] || 'http://proxy.mtt.rs'

  def self.request(url, options: {}, verb: :get)
    query = { url: url, options: options }
    HTTParty.send(verb, PROXY_URL, query: query, timeout: TIMEOUT)
  end
end
