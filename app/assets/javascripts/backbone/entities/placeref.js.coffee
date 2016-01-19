@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Placeref extends Entities.Model
    # idAttribute: "placeref_id"

  class Entities.PlacerefCollection extends Entities.Collection
    model: Entities.Placeref
    url: '/placerefs'


  API =
    # all placerefs less bio not yet mapped to author/work
    getPlacerefEntities: (data, cb) ->
      placerefs = new Entities.PlacerefCollection()
      placerefs.fetch
        data: data
        success: ->
          cb placerefs

    getPlacerefEntity: (prid, cb) ->
      @placeref = Placeref.find(prid)
      console.log 'API' + @placeref, prid
      cb @placeref

  App.reqres.setHandler "placeref:entities", (data={},cb) ->
    API.getPlacerefEntities data, cb

  App.reqres.setHandler "placeref:entity", (prid,cb) ->
    API.getPlacerefEntities prid, cb
