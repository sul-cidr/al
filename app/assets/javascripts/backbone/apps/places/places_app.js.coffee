@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

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

    showAreaSummary: (activePlacerefs) ->
      PlacesApp.Show.Controller.showAreaSummary(activePlacerefs)

    # these go and do a spatial filter
    showBorough: (id) ->
      PlacesApp.Show.Controller.showBorough(id)

    showHood: (id) ->
      PlacesApp.Show.Controller.showHood(id)

  App.vent.on "authors-panel:open", ->
    PlacesApp.List.Controller.togglePanel()
    map.setActiveArea('viewport-authors')
    map.setView([51.5120, -0.0928], 12)

  App.vent.on "area:show", (area) ->
    id = area.get("id")
    if id >= 95
      console.log 'places_app area:show', id
      Backbone.history.navigate("boroughs/" + id)
      API.showBorough(id)
    else
      console.log 'places_app area:show', id
      Backbone.history.navigate("hoods/" + id)
      API.showHood(id)

  App.vent.on "placerefs:filtered", (activePlacerefs) ->
    # CHECK: placeref filtering happens from both directions
    # this renders Area Summary whether visible or not
    API.showAreaSummary activePlacerefs

  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    # Backbone.history.navigate("places", true)
    API.startPlaces()
