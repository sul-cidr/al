@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class PlacesApp.Router extends Marionette.AppRouter
    appRoutes:
      "places": "startPlaces"
      "places/:id": "showPlace"
      # "hoods/:id": "showHood"

  API =
    startPlaces: ->
      # console.log 'API.startPlaces fired'
      PlacesApp.List.Controller.startPlaces()
      Backbone.history.navigate("places")

    listPlaces: ->
      PlacesApp.List.Controller.listPlaces()

    showPlaceSummary: (activePlacerefs) ->
      PlacesApp.Show.Controller.showPlaceSummary(activePlacerefs)

    # these go and do a spatial filter
    showPlace: (id) ->
      PlacesApp.Show.Controller.showPlace(id)

  App.vent.on "authors-panel:open", ->
    PlacesApp.List.Controller.togglePanel()
    map.setActiveArea('viewport-authors')
    map.setView([51.5120, -0.0928], 12)

  App.vent.on "place:show", (area) ->
    id = area.get("id")
    console.log 'place:show triggered', id
    Backbone.history.navigate("places/" + id)
    API.showPlace(id)

  App.vent.on "placerefs:filtered", (activePlacerefs) ->
    # CHECK: placeref filtering happens from both directions
    # this renders Area Summary whether visible or not
    API.showPlaceSummary activePlacerefs

  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    # Backbone.history.navigate("places", true)
    API.startPlaces()
