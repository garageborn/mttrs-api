class ElasticController < ApplicationController
  def index
    params[:offset] ||= 0
    @links = Link.recent.limit(30).offset(params[:offset])

    render 'elastic/index'
  end
end
