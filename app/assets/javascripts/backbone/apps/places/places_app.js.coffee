@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  # console.log 'PlacesApp started'

  alertPrivate = (message) ->
    console.log "Private alert: " + message

  PlacesApp.alertPublic = (message) ->
    console.log 'I will now call alertPrivate'
    alertPrivate message

  ##
  # places have geometry; areas are a subset of places, incl.
  # boroughs/wards/neighborhoods
  # place references in text refer to places
  # navigation can drill down in places, some of which
  # are the object of placerefs

  class PlacesApp.Router extends Marionette.AppRouter
    appRoutes:
      "places": "listPlaces"
      # "placerefs":
      # "areas": "listAreas"
      # "area/:id": "showArea"

  API =
    startPlaces: ->
      # console.log 'API.startPlaces()'
      PlacesApp.List.Controller.startPlaces()

    listAreas: ->
      PlacesApp.List.Controller.listAreas()

    listPlaces: ->
       PlacesApp.List.Controller.listPlaces()

    # # detail page for an area (neighborhood/district)
    showArea: (id) ->
      alert 'showArea, id: '+id

  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    API.startPlaces()
