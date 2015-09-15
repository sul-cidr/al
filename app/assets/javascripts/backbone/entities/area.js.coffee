@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Area extends Entities.Model

  class Entities.AreaCollection extends Entities.Collection
    model: Entities.Area
    url: '/areas.json'

  API =

    # 'areas' for navigating places
    getAreaEntities: (cb) ->
      areas = new Entities.AreaCollection()
      areas.fetch
        success: ->
          cb areas 

  App.reqres.setHandler "area:entities", (cb) ->
    API.getAreaEntities cb
