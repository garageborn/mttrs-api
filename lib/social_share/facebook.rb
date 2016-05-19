module SocialShare
  class Facebook
    def self.count(url)
      request = Proxy.request("http://graph.facebook.com/?id=#{ url }")
      request.parsed_response.try(:[], 'shares').to_i
    rescue StandardError
    end
  end
end
