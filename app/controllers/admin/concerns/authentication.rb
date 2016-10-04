module Admin
  module Concerns
    module Authentication
      extend ActiveSupport::Concern

      included do |base|
        before_action :authenticate
      end

      def authenticate
        user = authenticate_with_http_basic { |username, password| Auth.call(username, password) }
        request_http_basic_authentication unless user.present?
      end
    end
  end
end
