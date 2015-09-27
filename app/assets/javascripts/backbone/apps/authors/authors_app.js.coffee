@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class AuthorsApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startAuthors"
      "authors/:author_id": "passAuthorModel"

      "passages/:work_id": "passWorkModel"

      # '/authors/:categoryid':
      # "dimensions": "listDimensions"
      # "categories": "listCategories"


  API =
    startAuthors: ->
      AuthorsApp.List.Controller.startAuthors()

    passAuthorModel: (author_id) ->
      # forwards author model to showAuthor function
      App.request "author:entity", author_id, (author) =>
        AuthorsApp.List.Controller.showAuthor(author)

    passWorkModel: (work_id) ->
      # forwards work model to listWorksPassages function
      App.request "work:entity", work_id, (work) =>
        AuthorsApp.List.Controller.listWorkPassages(work)


  App.addInitializer ->
    new AuthorsApp.Router
      controller: API
    # CHECK: started by appRoute ""
    # API.startAuthors()
