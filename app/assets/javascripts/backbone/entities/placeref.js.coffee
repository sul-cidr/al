@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Placeref extends Entities.Model
    # idAttribute: "placeref_id"

  class Entities.PlacerefCollection extends Entities.Collection
    model: Entities.Placeref
    url: '/placerefs.json'
    # idAttribute: "placeref_id"
  placerefs = new Entities.PlacerefCollection()

  API =
    # all placeref: not especially useful
    getPlacerefEntities: (cb) ->
      # placerefs = new Entities.PlacerefCollection()
      placerefs.fetch
        success: ->
          console.log 'all '+placerefs.models.length+' authors at first'
          cb placerefs

    getPlacerefsAuthor: (id, cb) ->
      # placerefs = new Entities.PlacerefCollection()
      placerefs.fetch
        success: ->
          # console.log placerefs
          filterId = _.filter(placerefs.models,(item) ->
            item.get("author_id") == id
          )
          placerefs.reset(filterId)
          cb placerefs
        error: ->
          onErrorHandler

    getPlacerefsCategory: (id, cb) ->
      # get author_ids for category members
      # placerefs = new Entities.PlacerefCollection()
      placerefs.fetch
        success: ->
          filterId = _.filter(placerefs.models,(item) ->
            item.get("author_id") == id
          )
          placerefs.reset(filterId)
          cb placerefs
        error: ->
          onErrorHandler

    onErrorHandler: (collection, response, options) ->
      console.log 'placerefs fetch onerrorhandler'
      console.log response.responseText

  App.reqres.setHandler "placeref:entities", (cb) ->
    API.getPlacerefEntities cb

  App.reqres.setHandler "placerefs:author", (id, cb) ->
    API.getPlacerefsAuthor id, cb

  App.reqres.setHandler "placerefs:category", (id, cb) ->
    API.getPlacerefsCategory id, cb
