class PublishersController < ApplicationController
  def index
    publishers = Publisher.all
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
end
