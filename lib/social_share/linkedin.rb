module SocialShare
  class Linkedin
    BASE_URL = 'https://www.linkedin.com/countserv/count/share'.freeze

    def self.count(url)
      request = HTTParty.get(BASE_URL, query: { format: 'json', url: url })
      request.parsed_response.try(:[], 'count').to_i
    rescue StandardError
    end
  end
end
