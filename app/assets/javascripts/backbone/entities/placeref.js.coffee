@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Placeref extends Entities.Model
    # idAttribute: "placeref_id"

  class Entities.PlacerefCollection extends Entities.Collection
    model: Entities.Placeref
    url: '/placerefs'

    # idAttribute: "placeref_id"
  # placerefs = new Entities.PlacerefCollection()

  API =
    # all placerefs less bio not yet mapped to author/work
    getPlacerefEntities: (data, cb) ->
      placerefs = new Entities.PlacerefCollection()
      placerefs.fetch
        data: data
        success: ->
          # TODO: why are author_ids missing?
          # filter = _.filter(placerefs.models,(item) ->
          #   item.get("author_id") > -1;
          # )
          # placerefs.reset(filter)
          cb placerefs

  App.reqres.setHandler "placeref:entities", (data={},cb) ->
    API.getPlacerefEntities data, cb
