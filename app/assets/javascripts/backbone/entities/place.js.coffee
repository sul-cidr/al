@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model
    idAttribute: "place_id"

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    url: '/places'
    idAttribute: "place_id"

  API =
    # all places: not especially useful
    getPlaceEntities: (cb) ->
      places = new Entities.PlaceCollection()
      places.fetch
        success: ->
          # TODO make sense to filter by geom type here? e.g. separatehandlers
          cb places

  App.reqres.setHandler "place:entities", (cb) ->
    API.getPlaceEntities cb
