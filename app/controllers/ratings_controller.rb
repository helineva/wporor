class RatingsController < ApplicationController
  def index
    expiry_time = 5.minutes
    @recent_ratings = Rails.cache.fetch('recent_ratings', expires_in: expiry_time){ Rating.recent }
    @most_active_users = Rails.cache.fetch('most_active_users', expires_in: expiry_time){ User.most_active(3) }
    @best_beers = Rails.cache.fetch('best_beers', expires_in: expiry_time){ Beer.top(3) }
    @best_breweries = Rails.cache.fetch('best_breweries', expires_in: expiry_time){ Brewery.top(3) }
    @best_styles = Rails.cache.fetch('best_styles', expires_in: expiry_time){ Style.top(3) }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
