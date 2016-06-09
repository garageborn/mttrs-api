module Social
  module Strategies
    module Direct
      class Facebook
        def self.count(url)
          request = Proxy.request("http://graph.facebook.com/?id=#{ url }")
          return unless request && request.parsed_response
          request.parsed_response.try(:[], 'shares').to_i
        rescue *Proxy::RESCUE_FROM
        end
      end
    end
  end
end
