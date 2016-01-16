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
          # console.log 'places', places
          cb places

  App.reqres.setHandler "place:entities", (filter={}, cb) ->
    # console.log 'getPlaceEntities filter', filter
    API.getPlaceEntities filter, cb
  # App.reqres.setHandler "place:entities", (cb) ->
  #   API.getPlaceEntities cb
