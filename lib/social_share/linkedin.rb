module SocialShare
  class Linkedin
    BASE_URL = 'https://www.linkedin.com/countserv/count/share'.freeze

    def self.count(url)
      request = Proxy.request(
        BASE_URL,
        options: { query: { format: 'json', url: url } }
      )
      request.parsed_response.try(:[], 'count').to_i
    rescue StandardError
    end
  end
end
