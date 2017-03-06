module Concerns
  module HasNestedForm
    extend ActiveSupport::Concern

    included do
      class << self
        def has_nested_form(name, options)
          prepopulate = options.delete(:prepopulate)
          klass = options.delete(:klass)

          populator = lambda do |populator_options|
            nested_populator(name, klass, populator_options)
          end
          prepopulator = lambda do |prepopulator_options|
            nested_prepopulator(name, klass, prepopulator_options) if prepopulate
          end

          collection(name, options.merge(populator: populator, prepopulator: prepopulator))
        end
      end
    end

    private

    def nested_populator(_name, klass, options)
      fragment = options[:fragment]
      collection = options[:model]
      index = options[:index]

      if fragment[:id].to_s.blank?
        item = nil
      else
        item = collection.detect { |r| r.id.to_s == fragment[:id].to_s }
      end

      if fragment['_destroy'] == '1'
        collection.delete_at(index)
        return skip!
      else
        item ? item : collection.append(klass.new)
      end
    end

    def nested_prepopulator(name, klass, _options)
      send(name) << klass.new if send(name).size.zero?
    end
  end
end
