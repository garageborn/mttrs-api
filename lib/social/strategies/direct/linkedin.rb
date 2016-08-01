module Social
  module Strategies
    module Direct
      class Linkedin
        BASE_URL = 'https://www.linkedin.com/countserv/count/share'.freeze

        def self.count(url)
          request = Proxy::Request.run(
            BASE_URL,
            options: { query: { format: 'json', url: url } }
          )
          return unless request && request.parsed_response
          request.parsed_response.try(:[], 'count').to_i
        rescue *Proxy::Request::RESCUE_FROM
        end
      end
    end
  end
end
