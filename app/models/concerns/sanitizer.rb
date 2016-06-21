module Concerns
  module Sanitizer
    extend ActiveSupport::Concern

    included do
      class << self
        def sanitizer(*attributes)
          before_validation do
            attributes.each { |attribute| sanitize_attribute(attribute, self[attribute]) }
          end

          attributes.each do |attribute|
            define_method("#{ attribute }=") { |value| sanitize_attribute(attribute, value) }
          end
        end
      end

      def sanitize_attribute(attribute, value)
        self[attribute] = ActionView::Base.full_sanitizer.sanitize(value.to_s).strip
      end
    end
  end
end
