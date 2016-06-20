class ElasticController < ApplicationController
  def index
    params[:offset] ||= 0
    @stories = Story.recent.limit(30).offset(params[:offset])

    render 'elastic/index'
  end
end
