module Resolvers
  module StoryType
    class OtherLinks < Base
      def resolve
        return obj.other_links.filter(filters) if publisher_slug.blank?
        obj.links.where.not(id: obj.main_publisher_link(publisher_slug)).filter(filters)
      end

      private

      def publisher_slug
        args['publisher_slug']
      end

      def filters
        args.except('publisher_slug')
      end

      memoize :publisher_slug, :filters
    end
  end
end
