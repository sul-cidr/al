@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  List.Controller =

    listAuthors: ->
      authorsCollection = new List.Collection

      authorsCollection.fetch()

      authorsView = new List.AuthorsView({
        collection: authorsCollection
      })

      App.authorsRegion.show authorsView 

