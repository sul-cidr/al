this.AL.module("PlacesApp", function(PlacesApp, App, Backbone, Marionette, $, _) {
  var API;
  this.startWithParent = false;
  API = {
    showPlaces: function() {
      return PlacesApp.Show.Controller.showPlaces();
    }
  };
  return PlacesApp.on("start", function() {
    return API.showPlaces();
  });
});

