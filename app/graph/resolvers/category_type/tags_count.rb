module Resolvers
  module CategoryType
    class TagsCount < Base
      def resolve
        obj.tags.filter(args).pluck(:id).uniq.count
      end
    end
  end
end
