module SocialShare
  class Linkedin
    def self.count(url)
      request = HTTParty.get("https://www.linkedin.com/countserv/count/share?format=json&url=#{ url }")
      request.parsed_response.try(:[], 'count').to_i
    end
  end
end
