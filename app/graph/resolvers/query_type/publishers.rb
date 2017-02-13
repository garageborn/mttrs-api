module Resolvers
  module QueryType
    class Publishers < Base
      def resolve
        cache_for(:publishers).expires_in 1.hour
        Publisher.filter(args)
      end
    end
  end
end
