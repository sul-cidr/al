@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Placeref extends Entities.Model
    # idAttribute: "placeref_id"

  class Entities.PlacerefCollection extends Entities.Collection
    model: Entities.Placeref
    url: '/placerefs'
    # idAttribute: "placeref_id"
  placerefs = new Entities.PlacerefCollection()

  API =
    # all placeref: not especially useful
    getPlacerefEntities: (cb) ->
      # placerefs = new Entities.PlacerefCollection()
      placerefs.fetch
        success: ->
          # console.log 'all '+placerefs.models.length+' placerefs at first'
          cb placerefs

  App.reqres.setHandler "placeref:entities", (cb) ->
    API.getPlacerefEntities cb
