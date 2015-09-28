@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  # // Set up the handler
  App.commands.setHandler 'refreshMap', (what, model) ->
    API.refresh what, model

  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

    refresh: (what, model)->
      id = model.attributes.author_id
      App.request "placerefs:author", id, (placerefs) =>
        MapApp.Show.Controller.updateMap(placerefs)

  MapApp.on "start", ->
    controller: API
    API.showMap()
