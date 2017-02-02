module Concerns
  module GraphqlCache
    extend ActiveSupport::Concern

    included do
      after_action :set_graphql_expires
    end

    def add_graphql_expires(time)
      graphql_expires.push(time)
    end

    private

    def set_graphql_expires
      # return expires_now if graphql_expires.include?(:now)
      # expires_in(graphql_expires.min, public: true)
      expires_in(5.minutes, public: true)
    end

    def graphql_expires
      @graphql_expires ||= []
    end
  end
end
