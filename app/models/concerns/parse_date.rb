module Concerns
  module ParseDate
    extend ActiveSupport::Concern

    module ClassMethods
      def parse_date(date)
        return Time.zone.at(date.to_i) if date.is_a?(Integer) || date.to_i > 0
        Date.parse(date)
      end
    end
  end
end