@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Place extends Entities.Model

  class Entities.PlaceCollection extends Entities.Collection
    model: Entities.Place
    #url: Routes.users_path()
    url: '/places.json'

  API =
    getPlaceEntities: (cb) ->
    
    getPlaces: ->
      # not from the db yet 
      
      new Entities.PlaceCollection [
        { prefname: "Southwark", type: "area"}
        { prefname: "Bloomsbury", type: "area" }
        { prefname: "The Strand", type: "place"}
      ]

      # places = new Entities.PlaceCollection()
      # places.fetch
      #   success: ->
      #     cb places 

  App.reqres.setHandler "place:entities", (cb) ->
    API.getPlaceEntities cb

