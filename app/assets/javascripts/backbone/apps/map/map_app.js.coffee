@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  # // Set up the handler
  # App.commands.setHandler 'setFilter', (key, evaluator) ->
  #   API.setFilter key, evaluator

  App.vent.on "author:show", (author) ->
    API.filterByAuthor author

  App.vent.on "borough:show", (area) ->
    API.focusArea area

  App.vent.on "category:authors:show", (cat) ->
    API.filterByCategory cat

  App.vent.on "work:show", (work) ->
    API.filterForWork work

  App.vent.on "map:reset", ->
    API.clearFilters()

  App.vent.on "placeref:highlight", (id) ->
    # console.log 'map_app heard highlight id#', id
    MapApp.Show.Controller.onHighlightFeature 'placeref', id

  App.vent.on "placeref:unhighlight", (id) ->
    # console.log 'map_app heard unhighlight, id#', id
    MapApp.Show.Controller.onUnhighlightFeature 'placeref', id

  App.vent.on "area:highlight", (id) ->
    # console.log 'map_app heard highlight id#', id
    MapApp.Show.Controller.onHighlightFeature 'area', id

  App.vent.on "area:unhighlight", (id) ->
    # console.log 'map_app heard unhighlight, id#', id
    MapApp.Show.Controller.onUnhighlightFeature 'area', id

  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

    focusArea: (area) ->
      if area.get("area_type") == "hood"
        console.log 'map_app.API zoom to hood centroid', area.get("name")
        console.log '& filter for intersect of buffer'
      else
        console.log 'map_app.API zoom to borough', area.get("name")
        console.log '& filter for intersect'

    filterByArea: (area) ->
      MapApp.Show.Controller.setFilter 'area', (placeref) ->
        placeref.get("geom_wkt")

    filterByAuthor: (author) ->
      # on click feed selected author to setFilter(author)
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        placeref.get("author_id") == author.get("author_id")

    filterByAuthors: (author_ids, id) ->
      # console.log author.get("author_id")
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        author_ids.indexOf(placeref.get("author_id")) > 0

    filterByCategory: (cat) ->
      # build collection of authorhs having 'cat'
      id = cat.get("id")
      author_ids = []
      App.request "authors:category", id, (authors) =>
        # console.log authors
        _.each authors.models, (a) =>
          author_ids.push a.get("author_id")
          @filterByAuthors author_ids, id
        # console.log 'cat '+id+ ': ', author_ids

    filterForWork: (work) ->
      console.log 'map.API filterForWork()', work.get("work_id")
      MapApp.Show.Controller.setFilter 'work', (placeref) ->
        placeref.get("work_id") == work.get("work_id")

    clearFilters: ->
      MapApp.Show.Controller.clearFilters()

  MapApp.on "start", ->
    controller: API
    API.showMap()
