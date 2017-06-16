module Resolvers
  module StoryType
    class Publishers < Base
      def resolve
        publishers = ([main_publisher] + other_publishers).compact.uniq
        return publishers + fallback_publishers if limit.blank?
        return publishers.first(limit) if publishers.size > limit
        publishers + fallback_publishers(limit - publishers.size)
      end

      private

      def publisher_ids
        args['publisher_ids']
      end

      def publisher_slug
        args['publisher_slug']
      end

      def main_publisher
        return if publisher_ids.blank? && publisher_slug.blank?
        obj.main_publisher_link(slug: publisher_slug, ids: publisher_ids).try(:publisher)
      end

      def other_publishers
        return [] if publisher_ids.blank?
        ids = obj.links.publisher_ids(publisher_ids).popular.pluck(:publisher_id).uniq
        Publisher.where.not(id: main_publisher).where(id: ids)
      end

      def fallback_publishers(count = nil)
        obj.publishers.where.not(id: main_publisher).where.not(id: other_publishers).limit(count)
      end

      def limit
        limit = args['limit'].to_i
        return nil unless limit.positive?
        limit
      end

      memoize :limit, :publisher_ids, :publisher_slug, :main_publisher, :other_publishers
    end
  end
end
