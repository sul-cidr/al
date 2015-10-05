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
      "areas/:id": "showArea"

  API =
    startPlaces: ->
      # console.log 'API.startPlaces()'
      PlacesApp.List.Controller.startPlaces()

    listAreas: ->
      PlacesApp.List.Controller.listAreas()

    # # detail page for an area (neighborhood/district)
    showArea: (id) ->
      console.log 'route will run showArea',id
      PlacesApp.Show.Controller.showArea(id)


  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    API.startPlaces()
