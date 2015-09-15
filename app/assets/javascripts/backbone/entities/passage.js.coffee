@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Passage extends Entities.Model

  class Entities.PassageCollection extends Entities.Collection
    model: Entities.Passage
    url: '/passages.json'
    idAttribute: "passage_id"

  API =
    getWorkEntities: (cb) ->
      passages = new Entities.PassageCollection()
      passages.fetch
        success: ->
          cb passages

  App.reqres.setHandler "passage:entities", (cb) ->
    API.getPassageEntities cb