
  var buildGoogleMap = function initialize(lat, lng, radius, tweets) {
    var center = new google.maps.LatLng(lat, lng);
    
    var mapOptions = {
      center: center,
      zoom: 10
    };
    
    var map = new google.maps.Map(document.getElementById("map-canvas"),
        mapOptions);
  
    var geoCircle = new google.maps.Circle({
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.15,
      map: map,
      center: center,
      radius: radius * 3959 * 1609 //convert from miles to meters
    })
    
    var infowindow = new google.maps.InfoWindow()
    for (var i = 0; i < tweets.length; i++) {
     var marker = new google.maps.Marker({
        position: new google.maps.LatLng(tweets[i].coordinates[1], tweets[i].coordinates[0]),
        map: map,
        title: tweets[i].screen_name,
        text: tweets[i].text
      });
      
      google.maps.event.addListener(marker, 'click', (function (marker) {
        return function () {
          infowindow.setOptions({
            content: marker.title + '<br><br>' +marker.text,
            maxWidth: 200,
            position: marker.position
          });
          infowindow.open(map, marker);
        }
      })(marker));
    };
  };
