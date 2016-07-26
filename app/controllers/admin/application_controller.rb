module Admin
  class ApplicationController < ActionController::Base
    before_action :authenticate

    def concept(name, model = nil, options = {}, &block)
      options[:layout] ||= Admin::Layout::Cell::Application
      super(name, model, options, &block)
    end

    private

    def authenticate
      user = authenticate_with_http_basic { |username, password| Auth.call(username, password) }
      request_http_basic_authentication unless user.present?
    end
  end
end
