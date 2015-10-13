@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  App.vent.on "authors-panel:open", ->
    PlacesApp.List.Controller.togglePanel()
    map.setActiveArea('viewport-authors')
    map.setView([51.5120, -0.0928], 12)

  class PlacesApp.Router extends Marionette.AppRouter
    appRoutes:
      "places": "startPlaces"
      "boroughs/:id": "showBorough"
      "hoods/:id": "showHood"

  API =
    startPlaces: ->
      # console.log 'API.startPlaces fired'
      PlacesApp.List.Controller.startPlaces()

    listAreas: ->
      PlacesApp.List.Controller.listAreas()


    showBorough: (id) ->
      PlacesApp.Show.Controller.showBorough(id)

    showHood: (id) ->
      PlacesApp.Show.Controller.showHood(id)

  PlacesApp.on "area:show", (id) ->
    if id >= 95
      console.log 'places_app area:show', id
      PlacesApp.navigate("boroughs/" + id)
      API.showBorough(id)
    else
      console.log 'places_app area:show', id
      PlacesApp.navigate("hoods/" + id)
      API.showHood(id)

  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    # Backbone.history.navigate("places", true)
    API.startPlaces()
