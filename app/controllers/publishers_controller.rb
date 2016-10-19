class PublishersController < ApplicationController
  def index
    publishers = Publisher.filter(filter_params)
    render json: publishers
  end

  def show
    publisher = Publisher.find(publisher_params[:id])
    render json: publisher
  end

  private

  def publisher_params
    params.permit(:id)
  end

  def filter_params
    params.permit(:order_by_name)
  end
end
