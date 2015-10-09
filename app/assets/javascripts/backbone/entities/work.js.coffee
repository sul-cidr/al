@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Work extends Entities.Model
    idAttribute: "work_id"

  class Entities.WorkCollection extends Entities.Collection
    model: Entities.Work
    url: '/works'
    comparator: 'title'

  works = new Entities.WorkCollection()

  API =
    getWorkEntity: (workid, cb) ->
      # console.log 'works, from getWorkEntity', works
      # window.works = works
      work = works._byId[workid]
      cb work

    getWorkEntities: (authid, cb) ->
      # works = new Entities.WorkCollection()
      works.fetch
        success: ->
          filterId = _.filter(works.models,(item) ->
            item.get("author_id") == authid;
          )
          works.reset(filterId)
          cb works

  App.reqres.setHandler "work:entities", (authid, cb) ->
    API.getWorkEntities authid, cb

  App.reqres.setHandler "work:entity", (workid, cb) ->
    API.getWorkEntity workid, cb
