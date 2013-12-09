namespace :db do
  desc "Uses a 4 hour capped Event Machine connection to public Twitter stream API to stock mongo db with only geo enabled tweets"
  task :stock_tweets => :environment do

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

    EM.run do
      client = EM::Twitter::Client.connect(tweet_stream)
      time_cap = 5 #seconds
      EventMachine.add_timer(time_cap) { EM::stop_event_loop }
      
      client.each do |tweet|
        tweet = JSON.parse(tweet)
        Tweet.create(
        text: tweet["text"],
        screen_name: tweet["user"]["screen_name"],
        coordinates: tweet["coordinates"]["coordinates"],
        created_at: tweet["created_at"]
        )
      end
    end
  end
end