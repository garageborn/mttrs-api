module Namespaced
  class Association
    attr_reader :model
    delegate :compact, :each, :include?, :inspect, :map, :to_a, :to_s, to: :namespaces
    delegate :namespace_ids, to: :model

    def initialize(model)
      @model = model
    end

    def set(values)
      @namespaces = nil
      model.write_attribute(:namespace_ids, values_to_namespace_ids(values))
      namespaces
    end

    def namespaces
      @namespaces ||= ::Namespace.where(id: namespace_ids)
    end

    def <<(namespace)
      values = values_to_namespace_ids(namespace)
      set(namespace_ids + values)
    end

    def +(other)
      (namespaces + other.namespaces).compact.uniq
    end

    def delete(value)
      namespace_id = value
      namespace_id = value.id if value.is_a?(::Namespace)
      set(namespace_ids - [namespace_id])
    end

    private

    def values_to_namespace_ids(values)
      ids = case
            when values.is_a?(Namespace) then [values.id]
            when values.try(:first).respond_to?(:id) then values.map(&:id)
            when values.is_a?(Integer) then [values]
            else values
            end
      return ids.compact.uniq.sort if ids.is_a?(Array)
      ids
    end
  end
end
