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
      fragment, collection, index = options[:fragment], options[:model], options[:index]

      if fragment['_destroy'] == '1'
        collection.delete_at(index)
        return skip!
      else
        (item = collection[index]) ? item : collection.insert(index, klass.new)
      end
    end

    def nested_prepopulator(name, klass, _options)
      send(name) << klass.new if send(name).size.zero?
    end
  end
end
