@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false
  # console.log 'PlacesApp started'

  ##
  # places have geometry; areas are a subset of places, incl.
  # boroughs/wards/neighborhoods
  # place references in text refer to places
  # navigation can drill down in places, some of which
  # are the object of placerefs

  class PlacesApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startPlaces"
      "areas/:id": "passAreaModel"

  API =
    startPlaces: ->
      # console.log 'API.startPlaces()'
      PlacesApp.List.Controller.startPlaces()

    listAreas: ->
      PlacesApp.List.Controller.listAreas()

    # # detail page for an area (borough or neighborhood)
    passAreaModel: (id) ->
      App.request "area:entity", id, (area) =>
        # console.log 'pass', area.get("name")
        PlacesApp.Show.Controller.showArea(area)
        App.vent.trigger "area:show", area
        # return focus area from anywhere
        App.reqres.setHandler "area:model", ->
          return area


  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    API.startPlaces()
