@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Work extends Entities.Model

  class Entities.WorkCollection extends Entities.Collection
    model: Entities.Work
    url: '/works.json'
    idAttribute: "work_id"

  API =
    getWorkEntities: (id, cb) ->
      works = new Entities.WorkCollection()
      works.fetch
        success: ->
          filterId = _.filter(works.models,(item) ->
            item.get("author_id") == id;
          )
          works.reset(filterId)
          cb works

  App.reqres.setHandler "work:entities", (id, cb) ->
    API.getWorkEntities cb
