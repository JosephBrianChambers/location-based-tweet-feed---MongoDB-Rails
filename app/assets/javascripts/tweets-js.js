
  // var myApp = root.myApp = (root.myApp || {});
  
  $(document).ready(function () {
    $('.tweet-query').on('submit', function (event) {
      event.preventDefault();
      //TODO refactor to submit ajax for tweets and update dom
      
      //Establish Websocket connection for live feed updating
      var Socket = new WebSocket("ws://localhost:8080");
      Socket.onmessage = function (msg) {
        tweet = JSON.parse(msg.data);
        $('.tweets').prepend('<li>'+tweet.created_at+tweet.text+'</li>');
        $('.tweets').prepend();
        lastTweet = $('.tweets').children().last().remove();
      };
    });
  })

  
  
  
