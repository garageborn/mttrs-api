class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Tenant::Concerns::Controller

  private

  def default_serializer_options
    { root: false }
  end
end
