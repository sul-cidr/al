@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class PlacesApp.Router extends Marionette.AppRouter
    appRoutes:
      "areas": "startPlaces"
      "areas/:id": "showArea"
      # "hoods/:id": "showHood"

  API =
    startPlaces: ->
      # console.log 'API.startPlaces fired'
      PlacesApp.List.Controller.startPlaces()
      Backbone.history.navigate("areas")

    listAreas: ->
      PlacesApp.List.Controller.listAreas()

    showAreaSummary: (activePlacerefs) ->
      PlacesApp.Show.Controller.showAreaSummary(activePlacerefs)

    # these go and do a spatial filter
    showArea: (id) ->
      PlacesApp.Show.Controller.showArea(id)

  App.vent.on "authors-panel:open", ->
    PlacesApp.List.Controller.togglePanel()
    map.setActiveArea('viewport-authors')
    map.setView([51.5120, -0.0928], 12)

  App.vent.on "area:show", (area) ->
    id = area.get("id")
    console.log 'area:show triggered', id
    Backbone.history.navigate("areas/" + id)
    API.showArea(id)

  App.vent.on "placerefs:filtered", (activePlacerefs) ->
    # CHECK: placeref filtering happens from both directions
    # this renders Area Summary whether visible or not
    API.showAreaSummary activePlacerefs

  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    # Backbone.history.navigate("places", true)
    API.startPlaces()
