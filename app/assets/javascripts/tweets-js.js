
  // var myApp = root.myApp = (root.myApp || {});
  
  $(document).ready(function () {
    $('.tweet-query').on('submit', function (event) {
      //make ajax callto tweets-index and populate content
      event.preventDefault();
      debugger
    });
    
    var Socket = new WebSocket("ws://localhost:8080")
    Socket.onmessage = function (msg) {
      tweet = JSON.parse(msg.data)
      debugger
      //TODO use ejs template
      $('.tweets').prepend('<li>'+tweet.created_at+tweet.text+'</li>')
      $('.tweets').prepend()
      lastTweet = $('.tweets').children().last().remove()
    };
  })

  
  
  
