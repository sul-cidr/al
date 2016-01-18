@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Work extends Entities.Model
    idAttribute: "work_id"

  class Entities.WorkCollection extends Entities.Collection
    model: Entities.Work
    url: '/works'
    # comparator: (a) ->
    #   a.get 'year'
    comparator: 'sorter'
    # comparator: 'sortable_title'

  works = new Entities.WorkCollection()

  API =
    getWorkEntity: (workid, cb) ->
      # console.log 'works, from getWorkEntity', works
      # window.works = works
      work = works._byId[workid]
      cb work

    getWorkEntities: (cb) ->
      works.fetch
        success: ->
          # leave out bio essays
          filterCat = _.filter(works.models,(item) ->
            item.get("work_id") > 20399
          )
          works.reset(filterCat);
          cb works

    getWorksByAuthor: (authid, cb) ->
      # works = new Entities.WorkCollection()
      works.fetch
        success: ->
          filterId = _.filter(works.models,(item) ->
            item.get("author_id") == authid;
          )
          works.reset(filterId)
          cb works

    getWorksCategory: (filter, cb) ->
      console.log 'API.getWorksCategory', filter
      works.fetch
        data: filter
        success: ->
          cb works
      # works.fetch
      #   success: ->
      #     filterCat = _.filter(works.models,(item) ->
      #       item.get("work_id") > 20399 && # item.contains("categories", cat)
      #         item.get('categories').indexOf(cat) > -1;
      #     )
      #     works.reset(filterCat);
      #     # console.log 'filtered works', works
      #     cb works

  App.reqres.setHandler "works:author", (authid, cb) ->
    API.getWorksByAuthor authid, cb

  App.reqres.setHandler "work:entity", (workid, cb) ->
    API.getWorkEntity workid, cb

  App.reqres.setHandler "work:entities", (workid, cb) ->
    API.getWorkEntities workid, cb

  App.reqres.setHandler "works:category", (filter={}, cb) ->
    API.getWorksCategory filter, cb
