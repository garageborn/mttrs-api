module Namespaced
  module Model
    extend ActiveSupport::Concern

    module InstanceMethods
      extend Memoist

      def namespaces
        ::Namespaced::Association.new(self)
      end

      def namespaces=(value)
        namespaces.set(value)
      end

      def namespace_ids=(value)
        namespaces.set(value)
        write_attribute(:namespace_ids, value.to_a)
      end

      memoize :namespaces
    end

    included do
      class << self
        def namespaced_model(options = {})
          include InstanceMethods unless options[:through].present?

          unless defined?(namespace)
            define_singleton_method(:namespace) do |id|
              return joins(options[:through]) if options[:through].present?
              where("#{ table_name }.namespace_ids @> '{?}'", id)
            end
          end

          default_scope lambda {
            return all if ::Namespaced.current.blank?
            send(:namespace, ::Namespaced.current.id)
          }
        end
      end
    end
  end
end
