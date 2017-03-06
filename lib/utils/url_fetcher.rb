module Utils
  class UrlFetcher
    def self.run(url)
      Typhoeus.get(
        url,
        followlocation: true,
        headers: {
          'User-Agent' => Utils::UserAgent.sample,
          'Content-Type' => 'text/html; charset=utf-8'
        },
        ssl_verifypeer: false
      )
    rescue *Utils::NetworkErrors::RESCUE_FROM
    end
  end
end
