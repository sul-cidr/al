@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Work extends Entities.Model

  class Entities.WorkCollection extends Entities.Collection
    model: Entities.Work
    url: '/works.json'
    idAttribute: "work_id"

  API =
    getWorkEntities: (cb) ->
      works = new Entities.WorkCollection()
      works.fetch
        success: ->
          cb works

  App.reqres.setHandler "work:entities", (cb) ->
    API.getWorkEntities cb