@AL.module "ContentApp", (ContentApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = true

  # ContentApp is global router/API for the AL app
  #
  class ContentApp.Router extends Marionette.AppRouter
    appRoutes:
      "": "startAuthors"
      # "": "startContent"
      "authors": "startAuthors"
      "places": "startPlaces"
      "works": "startWorks"
      "search": "startSearch"
      "authors/:author_id": "showAuthor"
      "places/:id": "showArea"

      # TODO: getting authors per cat should be a route
      # "authors/:category_id": "showAuthors"
      "works/:author_id": "authorWorks"
      "workpassages/:src/:work_id": "workPassages"
      "search/:q": "searchPassages"


  API =
    startContent: ->
      # console.log ' in AL.ContentApp.API.startContent()'
      Backbone.history.navigate("authors", true)
      AL.ContentApp.Show.Controller.startContent()

    startAuthors: ->
      # console.log 'API.startAuthors from ContentApp'
      AL.AuthorsApp.List.Controller.startAuthors()

    startPlaces: ->
      # console.log 'API.startPlaces from ContentApp'
      AL.PlacesApp.List.Controller.startPlaces()

    startWorks: ->
      # console.log 'API.startWorks from ContentApp'
      AL.WorksApp.List.Controller.startWorks()

    startSearch: ->
      # console.log 'API.startSearch from ContentApp'
      AL.SearchApp.Show.Controller.startSearch()

    showAuthor: (author_id)->
      # console.log 'ContentApp.Router, showAuthor()', author_id
      # App.vent.trigger "map:reset"
      # get author model from id, forward to showAuthor()
      App.request "author:entity", author_id, (author) =>

        # console.log 'author', author
        AL.AuthorsApp.Show.Controller.showAuthor(author)

        App.reqres.setHandler "author:model", ->
          return author
    #
    showArea: (id)->
      # these are the voronoi polygons
      AL.PlacesApp.Show.Controller.showPlace(id)


    authorWorks: (author_id) ->
      console.log 'works/:author_id, API authorWorks()'
      App.request "author:entity", author_id, (author) =>
        console.log 'author model from API:', author
        AL.AuthorsApp.Show.Controller.listWorks author

    workPassages: (src, work_id) ->
      console.log 'workPassages: '+src, work_id
      # get work model from id, forward to sub-app controller
      App.request "work:entity", work_id, (work) =>
        if src == 'a'
          AL.AuthorsApp.Show.Controller.listWorkPassages(work)
        else if src == 'w'
          AL.WorksApp.Show.Controller.showWork(work)
        # returns current work
        App.reqres.setHandler "work:model", ->
          return work

    searchPassages: (q) ->
      # console.log 'ContentApp router API searchPassages',q
      AL.SearchApp.Show.Controller.searchPassages q


  ContentApp.on "start", ->
    new ContentApp.Router
      controller: API
    API.startContent()
