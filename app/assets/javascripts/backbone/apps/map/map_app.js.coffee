@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  console.log 'MapApp started'

  App.commands.setHandler "refreshMap", (what, model) ->
    API.refreshMap(what, model)

  # MapApp.commands.setHandler("refreshMap", function(cat){
  #   API.refreshMap(cat));
  # });

  API =
    showMap: ->
      App.request "authors:category", 0, (authors) =>
        console.log 'start map with all', authors.models.length
        MapApp.Show.Controller.showMap()

    refreshMap: (what, model)->
      id = model.attributes.id
      if what == 'category'
        console.log 'map ' + model.attributes.name +
        ' ('+id+')'
        MapApp.show.Controller.showMap(what,id)
      else
        console.log 'map '+model.attributes.prefname +
        ' ('+id+')'
        MapApp.show.Controller.showMap(what,id)
      # console.log 'refreshMap():', what, model
      # if what is an author, filter on placerefs for author_id
      # if what is category, build list of author_ids
      #   and placerefs for all


  MapApp.on "start", ->
    controller: API
    API.showMap()
