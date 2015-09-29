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
      # console.log author.get("author_id")
      MapApp.Show.Controller.setFilter 'author', (model) ->
        # console.log model.get("author_id"), author.get("author_id")
        model.get("author_id") == author.get("author_id")

    filterByAuthors: (cat) ->
      # build collection of authorhs having 'cat'
      id = cat.get("id")
      author_ids = []
      App.request "authors:category", id, (authors) =>
        # console.log authors
        _.each authors.models, (a) =>
          # console.log a
          author_ids.push a.get("author_id")
        console.log author_ids

      # MapApp.Show.Controller.setFilter 'author', (model) ->
      #   model.get("author_id") == author.get("author_id")


  MapApp.on "start", ->
    controller: API
    API.showMap()
