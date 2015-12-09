@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Area extends Entities.Model

  class Entities.AreaCollection extends Entities.Collection
    model: Entities.Area
    url: '/areas.json'

    filterById: (idArray) ->
      @reset _.map(idArray, ((id) ->
        @get id
      ), this)

  areas = new Entities.AreaCollection()

  API =
    # 'areas' for navigating places
    getAreaEntities: (cb) ->
      setTimer('getAreaEntities')
      areas.fetch
        success: ->
          cb areas
          console.timeEnd 'getAreaEntities'

    getAreaEntity: (id, cb) ->
      # console.log areas
      @area = areas._byId[id]
      cb @area

    getHoods: (id, cb) ->
      areas.fetch
        success: ->
          filterBorough = _.filter(areas.models,(item) ->
            boroughHoods[id].indexOf(item.get('id')) > -1
          )
          areas.reset(filterBorough);
          cb areas

  App.reqres.setHandler "area:entities", (cb) ->
    API.getAreaEntities cb

  App.reqres.setHandler "area:entity", (id, cb) ->
    console.log 'area entity', id
    API.getAreaEntity id, cb

  App.reqres.setHandler "borough:hoods", (id, cb) ->
    API.getHoods id, cb
