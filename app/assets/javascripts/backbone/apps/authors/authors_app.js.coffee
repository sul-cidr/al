@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class AuthorsApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startAuthors"
      "authors/:author_id": "showAuthor" # pass author_id
      "authors/:author_id/works": "listAuthorWorks"
      # "dimensions": "listDimensions"
      # "categories": "listCategories"


  API =
    startAuthors: ->
      # console.log 'API.startAuthors()'
      AuthorsApp.List.Controller.startAuthors()

    # single author
    showAuthor: (author_id) ->
      # new instance of authors/:author_id
      App.request "author:entity", author_id, (author) ->
        # console.log author, ' from API'
        AuthorsApp.List.Controller.showAuthor(author)
        # AuthorsApp.Show.Controller.showAuthor(author)

    listAuthorWorks: (author_id) ->
      # dunno

  App.addInitializer ->
    new AuthorsApp.Router
      controller: API
    # CHECK: start this here?
    API.startAuthors()
