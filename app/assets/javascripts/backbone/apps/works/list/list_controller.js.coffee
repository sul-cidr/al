@AL.module 'WorksApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startWorks: ->
      # set URL
      Backbone.history.navigate("works")
      App.request "works:category", 0, (works) =>
        @layout = @getLayoutView()

        @layout.on "show", =>
          AL.ContentApp.Show.Controller.showTab('works')
          @showTitle works
          @listCatWorks works

          @listDimensions()
          @listCategories("genre")

        App.worksRegion.show @layout

    getLayoutView: ->
      new List.Layout

    showTitle: (works) ->
      titleView = @getTitleView works
      @layout.headerRegion.show titleView

    getTitleView: (works) ->
      new List.Title
        collection: works

    listDimensions: ->
      # console.log 'showDimensions()'
      dimensionsView = new List.Dimensions
      @layout.dimensionsRegion.show dimensionsView

    listCategories: (dim) ->
      App.request "category:entities", (categories) =>
        # console.log 'listCategories for: ', dim
        categoriesView = @getCategoriesView categories, dim
        @layout.categoriesRegion.show categoriesView

    getCategoriesView: (categories, dim) ->
      new List.Categories
        collection: categories
        filter: (child, index, collection) ->
          child.get('dim') == dim

    listCatWorks: (works) ->
      # console.log arguments.callee.caller.toString()
      # console.log 'listCatWorks()', works
      worksCatView = @getCatWorksView works
      @layout.workListRegion.show worksCatView

    getCatWorksView: (works) ->
      new List.Works
        collection: works
        # className: 'work'

    searchPassages: (q) ->
      console.log 'works_app List.Controller.searchPassages()', q
      App.request "passages:search", q, (results) =>
        window.searchresults = results
        if results.length > 0
          resultsView = @getResultsView results
          @layout.workListRegion.show resultsView
        else
          $(".passagelist").html('<p>Sorry, no results...</p>')

      $(".search-passages h4").html('Mentions of <b>'+q+'</b>')

    getResultsView: (results) ->
      new List.SearchResults ({
        collection: results
        viewComparator: "passage_id"
        className: 'passages-works'
      })

# places is a model for passage display
    # listPlacePassages: (authid) ->
    #   prefname = authhash[authid]
    #
    #   window.authorPassages =
    #     _.filter @activeWorksPlaces, (wp) =>
    #       wp.model.attributes.author_id == authid
    #
    #   # get passage_ids for author
    #   window.passage_ids = []
    #   _.each authorPassages, (p) =>
    #     passage_ids.push p.model.attributes.passage_id
    #
    #   # retrieve single author's passages for an area
    #   App.request "passages:places", passage_ids, (place_passages) =>
    #     if App.authorContentRegion.$el.length > 0
    #       App.authorContentRegion.reset()
    #     placePassagesView = @getPlacePassagesView place_passages
    #
    #     App.placePassagesRegion.show placePassagesView
    #     App.placePassagesRegion.$el.fadeIn("slow")
    #     #
    #     $(".passages-places h4").html(authhash[authid])
    #
    # getPlacePassagesView: (place_passages) ->
    #   new Show.PlacePassages ({
    #     collection: place_passages
    #     viewComparator: "passage_id"
    #     className: 'passages-places'
    #   })
