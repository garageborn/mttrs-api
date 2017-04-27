module Resolvers
  module TimelineType
    class Stories
      class HomeTimeline < Base
        delegate :filters, :date, to: :obj
        RECENT_DAYS_AGO = 1

        class << self
          def filters(_args)
            { with_summary: true, order_by_summarized_at: true }
          end

          def last_story(filters:, cursor:)
            cursor = parse_cursor(cursor)
            filter_stories(filters).published_until(cursor).reorder(:published_at).last
          end

          def filter_stories(filters)
            ::Story.filter(filters)
          end

          def parse_cursor(cursor)
            return recent_end_at if cursor.to_i.zero?
            cursor = Time.zone.at(cursor).at_beginning_of_day
            recent?(cursor) ? recent_start_at : cursor
          end

          def recent?(date)
            return if date.blank?
            date > recent_start_at
          end

          def recent_start_at
            RECENT_DAYS_AGO.days.ago.at_beginning_of_day
          end

          def recent_end_at
            Time.zone.now.end_of_day
          end
        end

        def resolve
          return [] if date.blank?
          self.class.filter_stories(filters).published_between(start_at, end_at)
        end

        private

      def cursor
        return Time.zone.now.end_of_day if args['cursor'].to_i.zero?
        Time.zone.at(args['cursor']).at_beginning_of_day
      end

        def start_at
          return if date.blank?
          return self.class.recent_start_at if self.class.recent?(date)
          date.at_beginning_of_day
        end

        def end_at
          return if date.blank?
          return self.class.recent_end_at if self.class.recent?(date)
          date.end_of_day
        end
      end
    end
  end
end
