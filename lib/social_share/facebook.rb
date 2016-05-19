module SocialShare
  class Facebook
    def self.count(url)
      request = Proxy.request("http://graph.facebook.com/?id=#{ url }")
      return unless request.parsed_response
      request.parsed_response.try(:[], 'shares').to_i
    rescue StandardError => e
    end
  end
end
