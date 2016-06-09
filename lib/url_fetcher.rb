class UrlFetcher
  def self.run(url)
    HTTParty.get(
      url,
      headers: { 'User-Agent' => UserAgent.sample },
      verify: false
    )
  end
end
