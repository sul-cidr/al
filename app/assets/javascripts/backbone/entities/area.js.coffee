@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Area extends Entities.Model

  class Entities.AreaCollection extends Entities.Collection
    model: Entities.Area
    url: '/areas.json'

  areas = new Entities.AreaCollection()

  API =
    # 'areas' for navigating places
    getAreaEntities: (cb) ->
      # areas = new Entities.AreaCollection()
      areas.fetch
        success: ->
          cb areas

    getAreaEntity: (id, cb) ->
      # console.log areas
      @area = areas._byId[id]
      cb @area

    getHoods: (id, cb) ->
      # console.log 'id in getHoods()', String(id)
      areas.fetch
        success: ->
          # console.log 'areas', areas.models
          filterId = _.filter(areas.models,(item) ->
            # CHECK: WTF???? item.get("parent_id") == id;
            String(item.get("parent_id")) == String(id);
          )
          areas.reset(filterId)
          # console.log @areas
          cb areas

  App.reqres.setHandler "area:entities", (cb) ->
    API.getAreaEntities cb

  App.reqres.setHandler "area:entity", (id, cb) ->
    API.getAreaEntity id, cb

  App.reqres.setHandler "borough:hoods", (id, cb) ->
    API.getHoods id, cb
