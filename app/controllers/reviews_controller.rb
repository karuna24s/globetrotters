class ReviewsController < ApplicationController

  def index
    @reviews = Review.top_pick
    @destinations = Destination.all
  end

  def show
    @review = Review.find(params[:id])
    @destination = Destination.find(params[:destination_id])
  end

end