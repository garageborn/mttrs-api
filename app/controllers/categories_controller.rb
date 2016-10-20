class CategoriesController < ApplicationController
  def index
    categories = Category.filter(filter_params)
    render json: categories
  end

  def show
    category = Category.find(category_params[:id])
    render json: category
  end

  private

  def filter_params
    params.permit(:order_by_name, :order_by_stories_count, :ordered)
  end

  def category_params
    params.permit(:id)
  end
end
