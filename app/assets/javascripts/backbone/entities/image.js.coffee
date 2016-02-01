@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Image extends Entities.Model

  class Entities.ImageCollection extends Entities.Collection
    model: Entities.Image
    url: '/images'

  API =
    getImageEntities: (filter, cb) ->
      images = new Entities.ImageCollection()
      images.fetch
        data: filter
        success: ->
          console.log images
          cb images

  App.reqres.setHandler "image:entities", (filter={}, cb) ->
    API.getImageEntities filter, cb

  # class Entities.Place extends Entities.Model
  #   idAttribute: "place_id"

  # class Entities.PlaceCollection extends Entities.Collection
  #   model: Entities.Place
  #   url: '/places'
  #   idAttribute: "place_id"
  #
  # API =
  #   getPlaceEntities: (filter, cb) ->
  #     places = new Entities.PlaceCollection()
  #     places.fetch
  #       data: filter
  #       success: ->
  #         cb places
  #
  # App.reqres.setHandler "place:entities", (filter={}, cb) ->
  #   # console.log 'API.getPlaceEntities filter', filter
  #   API.getPlaceEntities filter, cb
