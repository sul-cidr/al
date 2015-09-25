@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Passage extends Entities.Model
    idAttribute: "passage_id"

  class Entities.PassageCollection extends Entities.Collection
    model: Entities.Passage
    url: '/passages'
    idAttribute: "passage_id"

  # passages = new Entities.PassageCollection

  API =
    getPassageEntities: (id, type, cb) ->
      # console.log 'getPassageEntities', id, type
      passages = new Entities.PassageCollection
      passages.fetch
        success: ->
          filterBio = _.filter(passages.models,(item) ->
            item.get("subject_id") == id;
          )
          # passages.reset(filterBio)
          filterWorks = _.filter(passages.models,(item) ->
            item.get("work_id") == id;
          )
          if type == "bio"
            passages.reset(filterBio)
            # window.biocoll = passages
            cb passages
          else if type == "work"
            passages.reset(filterWorks)
            cb passages

  App.reqres.setHandler "passage:entities", (id, type, cb) ->
    API.getPassageEntities id, type, cb
