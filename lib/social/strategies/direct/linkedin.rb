module Social
  module Strategies
    module Direct
      class Linkedin
        BASE_URL = 'https://www.linkedin.com/countserv/count/share'.freeze

        class << self
          def count(url)
            request = Proxy.request(
              BASE_URL,
              options: { query: { format: 'json', url: url } }
            )
            return unless request && request.success?
            parse(request.body).try(:[], 'count').to_i
          end

          def parse(body)
            json = body.to_s.scan(/(\{.+\})/).flatten.first
            return if json.blank?
            JSON.parse(json)
          end
        end
      end
    end
  end
end
