module Social
  module Strategies
    module Direct
      class Facebook
        def self.count(url)
          request = Proxy::Request.run("http://graph.facebook.com/?id=#{ url }")
          return unless request && request.parsed_response
          request.parsed_response.try(:[], 'shares').to_i
        rescue *Proxy::Request::RESCUE_FROM
        end
      end
    end
  end
end
