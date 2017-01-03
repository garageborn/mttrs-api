module Concerns
  module StripAttributes
    extend ActiveSupport::Concern

    included do
      class << self
        def strip_attributes(*attributes)
          before_validation do
            attributes.each { |attribute| sanitize_attribute(attribute, self[attribute]) }
          end

          attributes.each do |attribute|
            define_method("#{ attribute }=") { |value| sanitize_attribute(attribute, value) }
          end
        end
      end

      def sanitize_attribute(attribute, value)
        self[attribute] = Utils::StripAttributes.run(value)
      end
    end
  end
end
