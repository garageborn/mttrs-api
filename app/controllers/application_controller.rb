class ApplicationController < ActionController::API
  include ActionController::Serialization

  private

  def default_serializer_options
    { root: false }
  end
end
