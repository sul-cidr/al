@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Passage extends Entities.Model
    idAttribute: "passage_id"

  class Entities.PassageCollection extends Entities.Collection
    model: Entities.Passage
    url: '/passages'
    idAttribute: "passage_id"

  class Entities.PassageResultsCollection extends Entities.Collection
    model: Entities.Passage
    url: "/search.json"
    idAttribute: "passage_id"

  # passages = new Entities.PassageCollection

  API =
    # search for string 'q'
    searchPassages: (q, cb) ->
      console.log 'entities.passage.searchPassages()', q
      # execute a search here

      # returns collection of models
      passages = new Entities.PassageResultsCollection

      passages.fetch({
        data: {q: q}
        processData: true

        success: ->
          # console.log passages
          cb passages
      })

      # this works to return JSON
      # $.ajax({
      #     dataType: "json",
      #     url: "/search.json",
      #     data: {q:q},
      #     success: (json) ->
      #       console.log json
      #       cb json
      # })


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


    getPlacePassages: (passage_ids, cb) ->
      # console.log 'API.getPlacePassages', passage_ids
      placePassages = new Entities.PassageCollection
      placePassages.fetch
        success: ->
          # console.log placePassages
          filter = _.filter(placePassages.models,(item) ->
            passage_ids.indexOf(item.get("passage_id")) > -1
          )
          placePassages.reset(filter)
          cb placePassages

  App.reqres.setHandler "passage:entities", (id, type, cb) ->
    API.getPassageEntities id, type, cb

  App.reqres.setHandler "passages:places", (passage_ids, cb) ->
    API.getPlacePassages passage_ids, cb

  App.reqres.setHandler "passages:search", (q, cb) ->
    API.searchPassages q, cb
