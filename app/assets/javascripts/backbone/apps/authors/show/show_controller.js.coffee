@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  Show.Controller =

    showAuthors: ->
      authorsView = @getAuthorsView()
      App.authorsRegion.show authorsView
    
    getAuthorsView: ->
      new Show.Authors