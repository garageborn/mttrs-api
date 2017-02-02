module GraphqlCache
  def self.cache_for(key, context)
    GraphqlCacheInstance.new(key, context)
  end

  class GraphqlCacheInstance
    attr_reader :key, :context

    def initialize(key, context)
      @key = key
      @context = context
    end

    def expires_in(time)
      controller.add_graphql_expires(time)
    end

    def expires_now
      expires_in(:now)
    end

    private

    def controller
      context[:controller]
    end
  end
end
