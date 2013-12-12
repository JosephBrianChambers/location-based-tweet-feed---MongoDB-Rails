class TweetsController < ApplicationController
  def index
    #note sample search: radius 100 miles, center (long, lat): 29.9461729, 40.7061464
    radius_of_earth = 3959.0 #miles
    @lat    = params[:lat].to_f    || 0#40.7061464
    @long   = params[:long].to_f   || 0#29.9461729
    @radius = params[:radius].to_f || 0#1000
    @radius /= radius_of_earth
    
    p @lat, @long, @radius
    p params[:page]
    #Tweets in geo-circle descending by creation DateTime
    @all_tweets = Tweet.desc(:created_at).where(
      {"coordinates" => {"$geoWithin" => { "$centerSphere" => 
      [[ @long, @lat ], @radius ]}}})
    @tweets  =  @all_tweets.page(params[:page]).per(5)
    p @tweets.length
    
    
    respond_to do |format|
      format.html  { render :index }
      format.json  { render :json => {"tweets" => @tweets}}
    end
  end
end

