@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  App.vent.on "authors-panel:open", ->
    PlacesApp.List.Controller.togglePanel()
    map.setActiveArea('viewport-authors')
    map.setView([51.5120, -0.0928], 12)

  class PlacesApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startPlaces"
      "boroughs/:id": "passBoroughModel"
      "hoods/:id": "passHoodModel"

  API =
    startPlaces: ->
      console.log 'API.startPlaces fired'
      PlacesApp.List.Controller.startPlaces()

    listAreas: ->
      PlacesApp.List.Controller.listAreas()

    # generate detail page for a borough
    # get model for area id, pass to relevant controller method
    # and set trigger for map
    passBoroughModel: (id) ->
      App.request "area:entity", id, (borough) =>
        App.request "borough:hoods", id, (hoods) =>
          PlacesApp.Show.Controller.showBorough(borough, hoods)
          App.vent.trigger "area:show", borough
          # # return focus area from anywhere
          # App.reqres.setHandler "borough:model", ->
          #   return borough

    # generate detail page for a borough
    passHoodModel: (id) ->
      App.request "area:entity", id, (hood) =>
        # console.log 'appRoutes, get hood', hood.get("name")
        PlacesApp.Show.Controller.showHood(hood)
        App.vent.trigger "area:show", hood
      #   # return focus area from anywhere
      #   App.reqres.setHandler "hood:model", ->
      #       return hood

  App.addInitializer ->
    new PlacesApp.Router
      controller: API
    API.startPlaces()
