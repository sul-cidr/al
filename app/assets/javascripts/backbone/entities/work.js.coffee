@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Work extends Entities.Model
    idAttribute: "work_id"

  class Entities.WorkCollection extends Entities.Collection
    model: Entities.Work
    url: '/works'
    comparator: 'sortable_title' #.gsub(/A /,'').gsub(/The /,'')

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

    getWorksCategory: (cat, cb) ->
      works.fetch
        success: ->
          filterCat = _.filter(works.models,(item) ->
            item.get("work_id") > 20399 && # item.contains("categories", cat)
              item.get('categories').indexOf(cat) > -1;
          )
          works.reset(filterCat);
          # console.log 'filtered works', works
          cb works

  App.reqres.setHandler "works:author", (authid, cb) ->
    API.getWorkEntities authid, cb

  App.reqres.setHandler "work:entity", (workid, cb) ->
    API.getWorkEntity workid, cb

  App.reqres.setHandler "works:category", (cat, cb) ->
    API.getWorksCategory cat, cb
