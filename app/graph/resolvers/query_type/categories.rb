module Resolvers
  module QueryType
    class Categories < Base
      def resolve
        cache_for(:categories).expires_in 15.minutes
        Category.filter(args)
      end
    end
  end
end
