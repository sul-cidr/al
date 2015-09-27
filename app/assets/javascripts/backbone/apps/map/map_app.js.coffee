@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  console.log 'MapApp started'
  # App.request "author:active" (activeAuthor) =>
  #   console.log 'MapApp activeAuthor: ', activeAuthor
  App.request "category:active", (activeCategory) =>
    console.log 'MapApp activeCategory: ', activeCategory

  API =
    showMap: ->
      App.request "authors:category", 0, (authors) =>
        console.log 'active authors from MapApp:',authors
        MapApp.Show.Controller.showMap()

  MapApp.on "start", ->
    controller: API
    # API.showMap()
