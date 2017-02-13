module Concerns
  module ParseDate
    extend ActiveSupport::Concern

    module ClassMethods
      def parse_date(date)
        case date
        when Date then date
        when ActiveSupport::TimeWithZone then date
        when Integer then Time.zone.at(date.to_i)
        else Date.parse(date)
        end
      end
    end
  end
end
