@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  # // Set up the handler
  # App.commands.setHandler 'setFilter', (key, evaluator) ->
  #   API.setFilter key, evaluator

  App.vent.on "author:show", (author) ->
    API.filterByAuthor author

  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

    refresh: (what, model)->
      id = model.attributes.author_id
      App.request "placerefs:author", id, (placerefs) =>
        MapApp.Show.Controller.updateMap(placerefs)

    filterByAuthor: (author) ->
      # console.log author.get("author_id")
      MapApp.Show.Controller.setFilter 'author', (model) ->
        # console.log model.get("author_id"), author.get("author_id")
        # TODO one is integer the other string
        model.get("author_id") == author.get("author_id")

  MapApp.on "start", ->
    controller: API
    API.showMap()
