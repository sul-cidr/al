this.AL.module("AuthorsApp.Show", function(Show, App, Backbone, Marionette, $, _) {
  return Show.Controller = {

    showAuthors: function() {
      var authorsView;
      authorsView = this.getAuthorsView();
      return App.authorsRegion.show(authorsView);
    },
    
    getAuthorsView: function() {
      return new Show.Authors;
    }
  };
});