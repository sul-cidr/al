@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  # // Set up the handler
  # App.commands.setHandler 'setFilter', (key, evaluator) ->
  #   API.setFilter key, evaluator

  App.vent.on "author:show", (author) ->
    API.filterByAuthor author

  App.vent.on "category:authors:show", (cat) ->
    API.filterByCategory cat

  App.vent.on "work:show", (work) ->
    API.filterForWork work

  App.vent.on "map:reset", ->
    API.clearFilters()

  App.vent.on "placeref:highlight", (id) ->
    # console.log 'map_app heard highlight id#', id
    MapApp.Show.Controller.onHighlightFeature id

  App.vent.on "placeref:unhighlight", (id) ->
    # console.log 'map_app heard unhighlight, id#', id
    MapApp.Show.Controller.onUnhighlightFeature id

  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

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
        console.log 'cat '+id+ ': ', author_ids

    filterForWork: (work) ->
      console.log 'map.API filterForWork()', work.get("work_id")
      MapApp.Show.Controller.setFilter 'work', (placeref) ->
        placeref.get("work_id") == work.get("work_id")

    clearFilters: ->
      MapApp.Show.Controller.clearFilters()

  MapApp.on "start", ->
    controller: API
    API.showMap()
