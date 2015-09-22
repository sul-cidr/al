@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showAuthor: (author) ->
      console.log 'Show.Controller.showAuthor(author): ', author
      authorView = @getAuthorView(author)
      App.authorsRegion.show authorView

    getAuthorView: (author) ->
      new Show.Author
