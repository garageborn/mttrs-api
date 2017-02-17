module Resolvers
  module TimelineType
    class Stories < Base
      delegate :type, :date, to: :obj

      def resolve
        return [] if date.blank?

        if type == :home
          Resolvers::TimelineType::Stories::HomeTimeline.call(obj, args, ctx)
        else
          Resolvers::TimelineType::Stories::DefaultTimeline.call(obj, args, ctx)
        end
      end
    end
  end
end
