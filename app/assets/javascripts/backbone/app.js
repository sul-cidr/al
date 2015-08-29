this.AL = (function(Backbone, Marionette) {
  var App;
  App = new Marionette.Application;
  
  App.addRegions({
    headerRegion: "#header-region",
    mapRegion: "#map-region",
    authorsRegion: "#authors-region",
    placesRegion: "#places-region",
    mainRegion: "#main-region",
    footerRegion: "#footer-region"
  });
  
  App.addInitializer(function() {
    App.module("HeaderApp").start();
    App.module("AuthorsApp").start();
    return App.module("PlacesApp").start();
  });
  
  App.on("initialize:after", function() {
    if (Backbone.history) {
      return Backbone.history.start();
    }
  });
  
  return App;

})(Backbone, Marionette);

