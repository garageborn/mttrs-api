module Social
  module Strategies
    module Direct
      class Facebook
        class << self
          def count(url)
            request = Proxy.request("http://graph.facebook.com/?id=#{ url }")
            return unless request && request.success?
            parse(request.body).try(:[], 'shares').to_i
          end

          private

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
