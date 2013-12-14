# Location based tweet feed

## About

Use this app [live on heroku](https://location-tweet-feed.herokuapp.com/)

This web app is written with Rails 3 and MongoDB and Mongoid. Currently, the Twitter streaming API is periodically consumed (all geo-located tweets) and content is saved to Mongo db indexed by geo-location and creation time. Users can provide a lat/long and radius to retrieve all tweets from the specified location and display the location where the tweets were generated on a map using Google Map API.

Content is rendered with Javascript and Ajax requests

App has WebSocket broadcasting capability for updating page with live tweets.

##TODO

* improve UI
* geolocation filter tweets during db population rake task to broadcast with WebSocket
* add filtering option to only render tweets with media content (pictures, video)


