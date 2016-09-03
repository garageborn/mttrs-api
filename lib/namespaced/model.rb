module Namespaced
  module Model
    extend ActiveSupport::Concern
    extend Memoist

    included do
      scope :namespace, lambda { |id|
        where("#{ table_name }.namespace_ids @> '{?}'", id)
      }

      default_scope lambda {
        return all if ::Namespaced.current.blank?
        namespace(::Namespaced.current.id)
      }
    end

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
end
