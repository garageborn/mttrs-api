class StoriesController < ApplicationController
  def index
    stories = Story.filter(filter_params)
    render json: stories
  end

  private

  def filter_params
    params.permit(
      :category_slug,
      :last_month,
      :last_week,
      :limit,
      :popular,
      :published_at,
      :publisher_slug,
      :recent,
      :today,
      :yesterday
    )
  end
end
