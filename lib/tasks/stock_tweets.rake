namespace :db do
  desc "Uses a time capped Event Machine connection to public Twitter stream API to stock mongo db with only geo enabled tweets"
  task :stock_tweets => :environment do
    #twitter stream api connection config
    tweet_stream = {
      :path => '/1.1/statuses/filter.json',
      :params => {:locations => '-180,-90,180,90'},#all geo tweets
      :oauth => {
        :consumer_key    => ENV["TWITTER_CONSUMER_KEY"],
        :consumer_secret => ENV["TWITTER_CONSUMER_SECRET"],
        :token           => ENV["TWITTER_TOKEN"],
        :token_secret    => ENV["TWITTER_TOKEN_SECRET"]
      }
    }


    Tweet.delete_all
    EM.run do  
      time_cap = 60*5 #seconds
      EventMachine.add_timer(time_cap) {EM::stop_event_loop}
      
      # #start web socket server
      # EM::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      #   #live tweets to draw live feed from
      #   live_tweets =[]
      #   feed_rate = 5 #seconds
      #   EventMachine::PeriodicTimer.new(feed_rate) do
      #     ws.send(live_tweets[-1])
      #     live_tweets = [live_tweets[-1]]
      #   end
        
        #connect to twitter stream api
        client = EM::Twitter::Client.connect(tweet_stream)
        client.on_error do |msg|
          p msg
        end

        client.each do |tweet|
          tweet = JSON.parse(tweet)
          
          abridged_tweet = {
            "text" => tweet["text"],
            "screen_name" => tweet["user"]        ? tweet["user"]["screen_name"] : "Blixa",
            "coordinates" => tweet["coordinates"] ? tweet["coordinates"]["coordinates"] : [0,0],
            "created_at"  => tweet["created_at"]
          }
          
          #live_tweets << abridged_tweet.to_json
          Tweet.create(
            text: abridged_tweet["text"],
            screen_name: abridged_tweet["screen_name"],
            coordinates: abridged_tweet["coordinates"],
            created_at: abridged_tweet["created_at"]
          )
        end
      #end # WebSocket server
    end
  end
end