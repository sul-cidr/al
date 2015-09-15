@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    url: '/places.json'
    idAttribute: "place_id"

  API =
    # all places: not especially useful
    getPlaceEntities: (cb) ->
      places = new Entities.PlaceCollection()
      places.fetch
        success: ->
          cb places

  App.reqres.setHandler "place:entities", (cb) ->
    API.getPlaceEntities cb

