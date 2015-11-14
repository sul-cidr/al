@AL.module 'WorksApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startWorks: ->
      console.log 'startWorks()'

      App.request "works:category", 0, (works) =>
        @layout = @getLayoutView()
        # console.log @layout
        # console.log works

        @layout.on "show", =>
          @showTitle works
          @listCatWorks works, 0

          @listDimensions()
          @listCategories("genre")

        # hold off rendering this
        App.worksRegion.show @layout

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

    listCatWorks: (works, category) ->
      worksCatView = @getCatWorksView works, category
      @layout.contentRegion.show worksCatView

    getCatWorksView: (works, category) ->
      new List.Works
        collection: works
        # className: 'work'

    getLayoutView: ->
      new List.Layout

    searchPassages: (q) ->
      console.log 'works_app List.Controller.searchPassages()', q
      App.request "passages:search", q, (results) =>
        console.log results
        resultsView = @getResultsView results, 'works'
        console.log resultsView
        @layout.contentRegion.show resultsView

    getResultsView: (results, type) ->
      new AL.AuthorsApp.Show.Passages ({
        collection: results
        viewComparator: "passage_id"
        className: if type == 'works' then 'passages-works' else 'passages-bio'
      })
