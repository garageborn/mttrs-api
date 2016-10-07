module Admin
  class BaseController < ActionController::Base
    include Admin::Concerns::Authentication
    include Admin::Concerns::Tenant

    def concept(name, model = nil, options = {}, &block)
      options[:layout] ||= Admin::Layout::Cell::Application
      super(name, model, options, &block)
    end
  end
end
