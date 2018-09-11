class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    raise
    Rating.create params.require(:rating).permit(:score, :beer_id)
    redirect_to ratings_path
  end
end
