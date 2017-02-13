require Rails.root.join('lib', 'graphql_cache')

module Resolvers
  class Base
    extend Memoist
    attr_reader :obj, :args, :ctx

    def self.call(*args)
      new(*args).resolve
    end

    def initialize(obj, args, ctx)
      @obj = obj
      @args = args.to_h
      @ctx = ctx
    end

    def resolve
      throw 'Please implement resolve method'
    end

    def cache_for(key)
      GraphqlCache.cache_for(key, ctx)
    end
  end
end
