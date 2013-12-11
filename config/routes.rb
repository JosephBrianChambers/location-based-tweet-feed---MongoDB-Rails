LocationTweets::Application.routes.draw do
  resources :tweets, :only => [:index]
  namespace :api do
    get 'tweets', to: 'tweets#index'
    get 'recient_tweet', to: 'tweets#recient_tweet'
  end
  
end
