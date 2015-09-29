@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  # // Set up the handler
  # App.commands.setHandler 'setFilter', (key, evaluator) ->
  #   API.setFilter key, evaluator

  App.vent.on "author:show", (author) ->
    API.filterByAuthor author

  App.vent.on "authors:show", (cat) ->
    API.filterByAuthors cat

  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

    filterByAuthor: (author) ->
      # on click feed selected author to setFilter(author)
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        placeref.get("author_id") == author.get("author_id")

    filterByCategory: (author_ids, id) ->
      # console.log author.get("author_id")
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        author_ids.indexOf(placeref.get("author_id")) > 0

    filterByAuthors: (cat) ->
      # build collection of authorhs having 'cat'
      id = cat.get("id")
      author_ids = []
      App.request "authors:category", id, (authors) =>
        # console.log authors
        _.each authors.models, (a) =>
          author_ids.push a.get("author_id")
          @filterByCategory author_ids, id
        console.log 'cat '+id+ ': ', author_ids


  MapApp.on "start", ->
    controller: API
    API.showMap()
