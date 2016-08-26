module Concerns
  module StripAttributes
    extend ActiveSupport::Concern
    REPLACEMENTS = {
      /[\r\n]+/ => ' ',
      '  ' => ' ',
      '&amp;' => '&'
    }.freeze

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
        new_value = ActionView::Base.full_sanitizer.sanitize(value.to_s)
        REPLACEMENTS.each { |regexp, value| new_value.gsub!(regexp, value) }
        self[attribute] = new_value
      end
    end
  end
end
