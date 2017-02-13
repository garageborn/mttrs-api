module Resolvers
  module QueryType
    class Link < Base
      def resolve
        cache_for(:link).expires_in 15.minutes
        Link.find(args['slug'])
      end
    end
  end
end
