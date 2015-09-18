@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  # places = App.request "place:entities", (places) =>
  #   console.log 'places: ', places

  API =
    showMap: ->
        MapApp.Show.Controller.showMap()

  MapApp.on "start", ->
    API.showMap()
