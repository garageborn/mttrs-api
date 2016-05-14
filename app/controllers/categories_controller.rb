class CategoriesController < ApplicationController
  def index
    categories = Category.filter(filter_params)
    render json: categories
  end

  private

  def filter_params
    params.permit(:order_by_name, :order_by_stories_count)
  end
end
