module Utils
  class UrlFetcher
    def self.run(url)
      HTTParty.get(
        url,
        format: :plain,
        headers: { 'User-Agent' => Utils::UserAgent.sample },
        verify: false
      )
    end
  end
end
