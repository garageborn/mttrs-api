class Proxy
  URL = 'http://gimmeproxy.com/api/getProxy?supportsHttps=true'.freeze



  def request
    HTTParty.get(URL)
  end

  private

  def at_rate_limit
    request.code == 429
  end

  def rate_limit
    request.headers['x-ratelimit-limit']
  end

  def rate_limit_remaining
    request.headers['x-ratelimit-remaining']
  end

  def next_rate_limit_window
    1.minute.from_now
  end
end
