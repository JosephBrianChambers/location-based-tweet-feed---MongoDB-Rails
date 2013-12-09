class TweetsController < ApplicationController
  def index
    #note sample search: radius 100 miles, center (long, lat): 29.9461729, 40.7061464
    radius_of_earth = 3959.0 #miles
    @lat    = params[:lat]    || 40.7061464
    @long   = params[:long]   || 29.9461729
    @radius = params[:radius] || 1000
    @radius /= radius_of_earth
    
    #Tweets in geo-circle descending by creation DateTime
    @all_tweets = Tweet.desc(:created_at).where(
      {"coordinates" => {"$geoWithin" => { "$centerSphere" => 
      [[ @long, @lat ], @radius ]}}})
    @tweets  =  @all_tweets.page(params[:page]).per(5)
    
    
    respond_to do |format|
      format.html  { render :index }
      format.json  { render :json => {"team" => @long, "leaders" => @leaders}}
    end
  end
end

