@AL.module 'WorksApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startWorks: ->
      # console.log 'startWorks()'
      # console.log 'startWorks caller:', arguments.callee.caller.toString()
      App.request "works:category", 0, (works) =>
        @layout = @getLayoutView()
        # console.log @layout
        # console.log works

        @layout.on "show", =>
          @showTitle works
          @listCatWorks works

          @listDimensions()
          @listCategories("genre")

        # hold off rendering this
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
        # categoriesView.on 'childview:works:filtered', (childView, model) ->
        #   console.log 'heard trigger', model
        # console.log categoriesView
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
        console.log 'search results:', results
        resultsView = @getResultsView results, 'works'
        console.log 'resultsView', resultsView

        @layout.workListRegion.show resultsView

    getResultsView: (results, type) ->
      new AL.AuthorsApp.Show.Passages ({
        collection: results
        viewComparator: "passage_id"
        className: if type == 'works' then 'passages-works' else 'passages-bio'
      })
    #
