module Admin
  class ApplicationController < ActionController::Base
    def concept(name, model=nil, options={}, &block)
      options[:layout] ||= Admin::Layout::Cell::Application
      super(name, model, options, &block)
    end
  end
end
