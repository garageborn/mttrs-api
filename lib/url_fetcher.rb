class UrlFetcher
  def self.run(url)
    HTTParty.get(
      url,
      headers: { 'User-Agent' => 'Firefox' },
      verify: false
    )
  end
end
