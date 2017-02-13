module Resolvers
  module QueryType
    class Publisher < Base
      def resolve
        cache_for(:publisher).expires_in 15.minutes
        ::Publisher.find(args['slug'])
      end
    end
  end
end
