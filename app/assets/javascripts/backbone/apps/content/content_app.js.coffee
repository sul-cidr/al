@AL.module "ContentApp", (ContentApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = true


  class ContentApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startContent"
      "authors": "startAuthors"
      "places": "startPlaces"
      "works": "startWorks"
      "authors/:author_id": "showAuthor"
      "works/:author_id": "authorWorks"
      "workpassages/:work_id": "workPassages"


  API =
    startContent: ->
      # console.log ' in AL.ContentApp.API.startContent()'
      Backbone.history.navigate("authors", true)
      AL.ContentApp.Show.Controller.startContent()

    startAuthors: ->
      # console.log 'API.startAuthors fired'
      # Backbone.history.navigate("authors")
      AL.AuthorsApp.List.Controller.startAuthors()

    startPlaces: ->
      # console.log 'API.startPlaces fired'
      AL.PlacesApp.List.Controller.startPlaces()

    startWorks: ->
      # console.log 'API.startWorks fired'
      # Backbone.history.navigate("works")
      AL.WorksApp.List.Controller.startWorks()

    showAuthor: (author_id)->
      console.log 'ContentApp.Router, showAuthor()'
      App.vent.trigger "map:reset"
      # get author model from id, forward to showAuthor()
      App.request "author:entity", author_id, (author) =>
        AL.AuthorsApp.Show.Controller.showAuthor(author)
        # returns current author
        App.reqres.setHandler "author:model", ->
          return author

    authorWorks: (author_id) ->
      App.request "author:entity", author_id, (author) =>
        AL.AuthorsApp.Show.Controller.listWorks author

    workPassages: (work_id) ->
      # get work model from id, forward to listWorkPassages()
      App.request "work:entity", work_id, (work) =>
        AL.AuthorsApp.Show.Controller.listWorkPassages(work)
        # returns current work
        App.reqres.setHandler "work:model", ->
          return work

  ContentApp.on "start", ->
    new ContentApp.Router
      controller: API
    API.startContent()


  # App.addInitializer ->
  #   new ContentApp.Router
  #     controller: API
    # API.startAuthors()
