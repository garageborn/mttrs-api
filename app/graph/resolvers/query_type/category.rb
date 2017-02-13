module Resolvers
  module QueryType
    class Category < Base
      def resolve
        cache_for(:category).expires_in 15.minutes
        ::Category.find(args['slug'])
      end
    end
  end
end
