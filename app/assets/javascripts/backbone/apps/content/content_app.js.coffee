@AL.module "ContentApp", (ContentApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = true


  class ContentApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startContent"
      "authors": "startAuthors"
      "places": "startPlaces"

  API =
    startContent: ->
      console.log ' in AL.ContentApp.API.startContent()'
      AL.ContentApp.Show.Controller.startContent()

    startAuthors: ->
      # console.log 'API.startAuthors fired'
      AL.AuthorsApp.List.Controller.startAuthors()

    startPlaces: ->
      # console.log 'API.startPlaces fired'
      AL.PlacesApp.List.Controller.startPlaces()


  App.addInitializer ->
    new ContentApp.Router
      controller: API
    API.startAuthors()

  # ContentApp.on "start", ->
  #   controller: API
  #   API.startContent()
