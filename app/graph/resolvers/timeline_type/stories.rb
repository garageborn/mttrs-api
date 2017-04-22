module Resolvers
  module TimelineType
    class Stories < Base
      delegate :type, to: :obj

      class << self
        def timeline(type)
          case type
          when :home then Resolvers::TimelineType::Stories::HomeTimeline
          when :publisher then Resolvers::TimelineType::Stories::PublisherTimeline
          else Resolvers::TimelineType::Stories::CategoryTimeline
          end
        end

        def filters(type:, args:)
          timeline(type).filters(args)
        end

        def last_story(type:, cursor:, filters:)
          timeline(type).last_story(cursor: cursor, filters: filters)
        end
      end

      def resolve
        timeline.call(obj, args, ctx)
      end

      def timeline
        self.class.timeline(type)
      end
    end
  end
end
