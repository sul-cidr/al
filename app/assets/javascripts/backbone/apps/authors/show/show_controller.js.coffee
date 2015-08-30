@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  Show.Controller =

    showAuthor: ->
      authorView = @getAuthorView()
      App.authorsRegion.show authorView
    
    getAuthorView: ->
      new Show.Author