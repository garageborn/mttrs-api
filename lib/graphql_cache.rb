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
    def base_key(&block)
      @base_key = block
    end

    def fetch(name)
      proc do |*args|
        key = get_key(name, *args)
        Rails.cache.fetch(key, expires_in: 3.hours) do
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

    def get_key(name, obj, args, ctx)
      base_key = get_base_key(obj, args, ctx)
      query_key = Base64.encode64(args.to_h.to_query)
      "#{ base_key }/#{ name }/#{ query_key }"
    end

    def get_base_key(*args)
      @base_key.call(*args)
    end
  end
end
