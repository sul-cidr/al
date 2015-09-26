@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showAuthor: (author) ->
      # console.log 'showAuthor()',author
      authorView = @getAuthorView author
      App.authorsRegion.show authorView

    getAuthorView: (author) ->
      # console.log author
      new List.AuthorLayout ({
        model: author
      })
