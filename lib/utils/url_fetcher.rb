module Utils
  class UrlFetcher
    def self.run(url)
      HTTParty.get(
        url,
        headers: { 'User-Agent' => Utils::UserAgent.sample },
        verify: false
      )
    end
  end
end
