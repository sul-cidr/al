@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model
    idAttribute: "place_id"

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    url: '/places'
    idAttribute: "place_id"

  API =
    getPlaceEntities: (filter, cb) ->
      places = new Entities.PlaceCollection()
      places.fetch
        data: filter
        success: ->
          cb places

  App.reqres.setHandler "place:entities", (filter={}, cb) ->
    # console.log 'API.getPlaceEntities filter', filter
    API.getPlaceEntities filter, cb
