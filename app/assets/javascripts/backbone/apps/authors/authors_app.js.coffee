@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  App.vent.on "places-panel:open", ->
    # console.log 'authors_app heard places-panel:close'
    AuthorsApp.List.Controller.togglePanel()
    map.setActiveArea('viewport-places')
    map.setView([51.5120, -0.0928], 12)

  class AuthorsApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startAuthors"
      "authors/:author_id": "passAuthorModel"
      "works/:author_id": "authorWorks"
      "workpassages/:work_id": "workPassages"

  API =
    startAuthors: ->
      # console.log 'API.startAuthors fired'
      AL.AuthorsApp.List.Controller.startAuthors()
      # AuthorsApp.List.Controller.startAuthors()

    authorWorks: (author_id) ->
      App.request "author:entity", author_id, (author) =>
        # console.log 'API.authorWorks', author_id
        AuthorsApp.Show.Controller.listWorks author

    workPassages: (work_id) ->
      App.request "work:entity", work_id, (work) =>
        AuthorsApp.Show.Controller.listWorkPassages(work)
        # returns current work from anywhere??
        App.reqres.setHandler "work:model", ->
          return work

    passAuthorModel: (author_id) ->
      App.vent.trigger "map:reset"
      # forwards author model to showAuthor function
      App.request "author:entity", author_id, (author) =>
        AuthorsApp.Show.Controller.showAuthor(author)
        App.vent.trigger "author:show", author
        # returns focus author from anywhere??
        App.reqres.setHandler "author:model", ->
          return author

  App.addInitializer ->
    new AuthorsApp.Router
      controller: API
    # CHECK: started by appRoute ""
    API.startAuthors()
