namespace :db do
  desc "Uses a 4 hour capped Event Machine connection to public Twitter stream API to stock mongo db with only geo enabled tweets"
  task :stock_tweets => :environment do

    tweet_stream = {
      :path => '/1.1/statuses/filter.json',
      :params => {:locations => '-180,-90,180,90'},#all geo tweets
      :oauth => {
        :consumer_key    => 'P1ktJO7mwtNk7Y6BNmKaQ',
        :consumer_secret => 'tvsLa5EsaHCnkpQ5age9lotPomSnwtD1KXgX5rx9LfA',
        :token => '1947982076-1SN9kQArVT1ZuhTFAI5ACP4VfA4eqImSDoZb7ry',
        :token_secret    => 'g9FVW2OfZhZTr1Gjll3B4BhYfayQX3eRQPEGOOPjYSUNT'
      }
    }

    EM.run do
      client = EM::Twitter::Client.connect(tweet_stream)
      time_cap = 3 #seconds
      EventMachine.add_timer(time_cap) { EM::stop_event_loop }
      
      client.each do |tweet|
        tweet = JSON.parse(tweet)
        Tweet.create(
        text: tweet["text"],
        screen_name: tweet["user"]["screen_name"],
        coordinates: tweet["coordinates"],
        created_at: tweet["created_at"]
        )
      end
    end
  end
end