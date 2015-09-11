@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    url: '/places.json'
    #url: Routes.users_path()

  API =
    # all places: not especially useful
    getPlaceEntities: (cb) ->
      places = new Entities.PlaceCollection()
      places.fetch
        success: ->
          cb places

    # 'areas' for navigating places
    getAreas: (cb) ->
      areas = new Entities.PlaceCollection()
      places.fetch
        success: ->
          cb places 

  App.reqres.setHandler "place:entities", (cb) ->
    API.getPlaceEntities cb

  App.reqres.setHandler "place:areas", (cb) ->
    API.getAreas cb
