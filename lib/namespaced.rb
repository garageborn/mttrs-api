module Namespaced
  autoload :Association, './lib/namespaced/association'
  autoload :Controller, './lib/namespaced/controller'
  autoload :Model, './lib/namespaced/model'

  class << self
    def current=(namespace)
      Thread.current[:namespace] = find(namespace)
    end

    def current
      Thread.current[:namespace]
    end

    private

    def find(value)
      return if value.blank?
      case
      when value.is_a?(::Namespace) then value
      when value.to_i.positive? then ::Namespace.find_by(id: value)
      else ::Namespace.find_by(slug: value)
      end
    end
  end
end
