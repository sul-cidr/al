@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    #url: Routes.users_path()
    url: '/places.json'

  API =
    getPlaceEntities: (cb) ->
      # console.log Entities
      places = new Entities.PlaceCollection()
      places.fetch
        success: ->
          cb places 
   
  App.reqres.setHandler "place:entities", (cb) ->
    API.getPlaceEntities cb

