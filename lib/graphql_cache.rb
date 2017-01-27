module GraphqlCache
  def self.define(object_type)
    object_type.send :extend, InstanceMethods
    yield(object_type.cache) if block_given?
  end

  module InstanceMethods
    extend Memoist

    def cache
      GraphqlCacheInstance.new
    end

    memoize :cache
  end

  class GraphqlCacheInstance
    extend Memoist

    def base_key(&block)
      keys[:base_key] = block
    end

    def define_key(name)
      keys[name] = proc do |*args|
        base_key = keys[:base_key].call(*args)
        object_key = block_given? ? yield(*args) : name
        "#{ base_key }/#{ object_key }"
      end
    end

    def fetch(name)
      proc do |*args|
        key = get_key(name, *args)
        Rails.cache.fetch(key, expires_in: 12.hours) do
          p '-------------------feeeeeeeeeeeeeeeeeeeeeetch', key
          yield(*args)
        end
      end
    end

    def clear(*args)
      key = get_base_key(*args)
      match_key = "#{ key }*"
      Rails.cache.delete_matched(match_key)
    end

    def clear_key(name, *args)
      key = get_key(name, *args)
      Rails.cache.delete(key)
    end

    private

    def keys
      {}
    end

    def get_key(name, *args)
      keys[name].call(args)
    end

    def get_base_key(*args)
      keys[:base_key].call(*args)
    end

    memoize :keys
  end
end
