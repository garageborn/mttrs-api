module Resolvers
  module QueryType
    class Tags < Base
      def resolve
        cache_for(:tags).expires_in 1.hour
        ::Tag.filter(args)
      end
    end
  end
end
