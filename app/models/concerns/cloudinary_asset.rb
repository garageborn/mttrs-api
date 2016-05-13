module Concerns
  module CloudinaryAsset
    extend ActiveSupport::Concern

    class Model
      attr_accessor :resource, :attribute
      delegate :present?, :blank?, to: :url

      def initialize(resource:, attribute:, styles: {})
        self.resource = resource
        self.attribute = attribute

        styles.each do |style, options|
          self.class.send(:define_method, style) { style(options.dup) }
        end
      end

      def url(options = {})
        byebug
        source = resource.read_attribute(attribute)
        return unless source.present?
        Cloudinary::Utils.cloudinary_url(source, options)
      end

      def to_s
        url
      end

      private

      def style(options)
        url(options)
      end
    end

    included do |base|
      def self.cloudinary_asset(name, attribute:, styles: {})
        define_method(name) do
          Model.new(resource: self, attribute: attribute, styles: styles)
        end
      end
    end
  end
end
