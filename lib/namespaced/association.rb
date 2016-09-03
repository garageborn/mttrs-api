module Namespaced
  class Association
    attr_reader :model
    delegate :to_a, :to_s, :each, :map, :inspect, to: :namespaces
    delegate :namespace_ids, to: :model

    def initialize(model)
      @model = model
    end

    def set(values)
      @namespaces = nil
      model.write_attribute(:namespace_ids, values_to_namespaces(values))
      namespaces
    end

    def namespaces
      @namespaces ||= ::Namespace.where(id: namespace_ids)
    end

    def <<(namespace)
      set(namespace_ids.push(namespace.id))
    end

    def delete(value)
      namespace_id = value
      namespace_id = value.id if value.is_a?(::Namespace)
      set(namespace_ids - [namespace_id])
    end

    private

    def values_to_namespaces(values)
      case
      when values.is_a?(Namespace) then values.id
      when values.try(:first).respond_to?(:id) then values.map(&:id)
      else values
      end.to_a.compact.uniq.sort
    end
  end
end
