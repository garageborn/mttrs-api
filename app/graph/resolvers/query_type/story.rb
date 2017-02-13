module Resolvers
  module QueryType
    class Story < Base
      def resolve
        cache_for(:story).expires_in 15.minutes
        ::Story.find(args['id'])
      end
    end
  end
end
