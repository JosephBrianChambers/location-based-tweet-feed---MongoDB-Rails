class Api::TweetsController < ApplicationController
  def index
    #note sample search: radius 100 miles, center (long, lat): 29.9461729, 40.7061464
    radius_of_earth = 3959.0 #miles
    @lat    = params[:lat].to_f    || 0
    @lng    = params[:lng].to_f    || 0
    @radius = params[:radius].to_f || 0
    @radius /= radius_of_earth

    #Tweets in geo-circle descending by creation DateTime
    @all_tweets = Tweet.desc(:created_at).where(
      {"coordinates" => {"$geoWithin" => { "$centerSphere" => 
      [[ @lng, @lat ], @radius ]}}})
    @tweets  =  @all_tweets.page(params[:page]).per(5)
    
    render :json => {"tweets" => @tweets, 
                     "lat" => @lat,
                     "lng" => @lng,
                     "radius" => @radius,
                     "page" => params[:page].to_i}
  end
end
