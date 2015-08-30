@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  List.Controller =

    listAuthors: ->
      authorsView = @getAuthorsView()
      App.authorsRegion.show authorsView
    
    getAuthorsView: ->
      new List.Authors