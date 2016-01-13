@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model
    idAttribute: "place_id"

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    url: '/places'
    idAttribute: "place_id"

  API =
    getPlaceEntities: (cb) ->
      places = new Entities.PlaceCollection()
      places.fetch
        success: ->
          console.log 'places', places
          cb places

  App.reqres.setHandler "place:entities", (cb) ->
    API.getPlaceEntities cb
