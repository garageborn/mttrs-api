module Concerns
  module Sanitizer
    extend ActiveSupport::Concern

    included do
      def self.sanitizer(*attributes)
        attributes.each do |attribute|
          define_method("#{ attribute }=") do |value|
            self[attribute] = ActionView::Base.full_sanitizer.sanitize(value.to_s).strip
          end
        end
      end
    end
  end
end
