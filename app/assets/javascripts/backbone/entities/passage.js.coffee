@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Passage extends Entities.Model

  class Entities.PassageCollection extends Entities.Collection
    model: Entities.Passage
    url: '/passages'
    idAttribute: "passage_id"

  # passages = new Entities.PassageCollection

  API =
    getPassageEntities: (id, type, cb) ->
      console.log 'getPassageEntities', id, type
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
            window.biocoll = passages
            cb passages
          else if type == "works"
            passages.reset(filterWorks)
            cb passages
    #
    # getAuthorEntities: (cb) ->
    #   authors.fetch
    #     success: ->
    #       # exclude Evans, Fielding, Boswell
    #       filterName = _.filter(authors.models,(item) ->
    #         item.get("author_id") < 10434;
    #       )
    #       authors.reset(filterName);
    #       cb authors

    # getBioPassages: (id, cb) ->
    #   passages = new Entities.PassageCollection
    #   console.log 'API.getBioPassages', id, passages
    #   filterBio = _.filter(passages.models,(item) ->
    #     item.get("subject_id") == id;
    #   )
    #   passages.reset(filterBio);
    #   cb passages

  App.reqres.setHandler "passage:entities", (id, type, cb) ->
    API.getPassageEntities id, type, cb

  # App.reqres.setHandler "passages:bio:author", (id, cb) ->
  #   API.getBioPassages id, cb
