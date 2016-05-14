class StoriesController < ApplicationController
  def index
    stories = Story.filter(filter_params)
    render json: stories
  end

  private

  def filter_params
    params.permit(:recent, :recent, :today, :yesterday, :last_week, :last_month)
  end
end
