@AL.module "ContentApp", (ContentApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = true


  class ContentApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startContent"
      "authors": "startAuthors"
      "places": "startPlaces"
      "works": "startWorks"

  API =
    startContent: ->
      # console.log ' in AL.ContentApp.API.startContent()'
      Backbone.history.navigate("authors", true)
      AL.ContentApp.Show.Controller.startContent()

    startAuthors: ->
      # console.log 'API.startAuthors fired'
      Backbone.history.navigate("authors")
      AL.AuthorsApp.List.Controller.startAuthors()

    startPlaces: ->
      # console.log 'API.startPlaces fired'
      AL.PlacesApp.List.Controller.startPlaces()

    startWorks: ->
      # console.log 'API.startWorks fired'
      Backbone.history.navigate("works")
      AL.WorksApp.List.Controller.startWorks()


  # App.addInitializer ->
  #   new ContentApp.Router
  #     controller: API
    # API.startAuthors()

  ContentApp.on "start", ->
    new ContentApp.Router
      controller: API
    API.startContent()
