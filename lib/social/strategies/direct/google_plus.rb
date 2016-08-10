module Social
  module Strategies
    module Direct
      class GooglePlus
        class << self
          def count(url)
            request = Proxy.request(
              "https://plusone.google.com/_/+1/fastbutton?url=#{ url }"
            )
            return unless request && request.success?
            return if request.parsed_response.blank?
            parse(request.body).to_i
          end

          private

          def parse(body)
            count = body.scan(/c: (\d+)/).flatten.first
            return if count.blank?
            count
          end
        end
      end
    end
  end
end
