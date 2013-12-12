
  // var myApp = root.myApp = (root.myApp || {});
  
  $(document).ready(function () {
    //pagiation
    $('.tweet-feed').on('click','.next', function (event) {
      event.preventDefault();
      var pageVal = $('.tweet-query').children('#page').val()
      pageVal = (parseInt(pageVal) + 1) + "";
      $('.tweet-query').children('#page').val(pageVal);
      $('.tweet-query').trigger('submit');
    });
    //pagination
    $('.tweet-feed').on('click','.previous', function (event) {
      event.preventDefault();
      var pageVal = $('.tweet-query').children('#page').val()
      pageVal = (parseInt(pageVal) - 1) + "";
      $('.tweet-query').children('#page').val(pageVal)
      $('.tweet-query').trigger('submit');
    })


    //on submit of location info
    $('.tweet-query').on('submit', function (event) {
      event.preventDefault();
      var tweetsIndexAPI = $(event.target).data("api")
      $.ajax({
        url: tweetsIndexAPI,
        data: {
          lat:    $(event.target).serializeJSON().lat,
          lng:    $(event.target).serializeJSON().lng,
          radius: $(event.target).serializeJSON().radius,
          page:   $(event.target).serializeJSON().page
        },
        type: "GET",
        success: function (data, status, jqXHR) {
          var tweetFeed = new EJS({url: '/tweetFeed.html.ejs'}).render(data);
          var paginationLinks = new EJS({url: '/paginationLinks.html.ejs'}).render(data);
          
          $('.tweet-feed').html(paginationLinks)
          $('.tweet-feed').append(tweetFeed);
          $('#map-canvas').html('');
          window.buildGoogleMap(data.lat, data.lng, data.radius, data.tweets);
        } 
      });
      
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

  
  
  
