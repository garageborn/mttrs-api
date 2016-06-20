module Concerns
  module Sanitizer
    extend ActiveSupport::Concern

    included do
      def self.sanitizer(*attributes)
        attributes.each do |attribute|
          define_method("#{ attribute }=") do |value|
            write_attribute(attribute, ActionView::Base.full_sanitizer.sanitize(value).strip)
          end
        end
      end
    end
  end
end
