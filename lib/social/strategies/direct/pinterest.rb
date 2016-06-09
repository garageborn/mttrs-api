module Social
  module Strategies
    module Direct
      class Pinterest
        class << self
          def count(url)
            request = Proxy.request(
              "http://api.pinterest.com/v1/urls/count.json?callback=nul&url=#{ url }"
            )
            return unless request && request.success?
            return if request.parsed_response.blank?
            parse(request.body).try(:[], 'count').to_i
          rescue *Proxy::RESCUE_FROM
          end

          private

          def parse(body)
            json = body.scan(/(\{.+\})/).flatten.first
            return if json.blank?
            JSON.parse(json)
          end
        end
      end
    end
  end
end
