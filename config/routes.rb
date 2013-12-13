LocationTweets::Application.routes.draw do
  root :to => 'tweets#index'
  resources :tweets, :only => [:index]
  namespace :api do
    get 'tweets', to: 'tweets#index'
    get 'recient_tweet', to: 'tweets#recient_tweet'
  end
  
end
