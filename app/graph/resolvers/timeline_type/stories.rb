module Resolvers
  module TimelineType
    class Stories < Base
      delegate :type, to: :obj

      class << self
        def timeline(type)
          home_timeline = Resolvers::TimelineType::Stories::HomeTimeline
          default_timeline = Resolvers::TimelineType::Stories::DefaultTimeline
          type == :home ? home_timeline : default_timeline
        end

        def filters(type, args)
          timeline(type).filters(args)
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
