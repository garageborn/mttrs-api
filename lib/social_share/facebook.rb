module SocialShare
  class Facebook
    def self.count(url)
      request = HTTParty.get("http://graph.facebook.com/?id=#{ url }")
      request.parsed_response.try(:[], 'shares').to_i
    end
  end
end
