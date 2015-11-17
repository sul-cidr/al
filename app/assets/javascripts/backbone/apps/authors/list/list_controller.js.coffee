@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startAuthors: ->
      # set URL
      Backbone.history.navigate("authors")

      # start with all (cat 0); filtered in the app
      App.request "authors:category", 0, (authors) =>
        @layout = @getLayoutView()
        console.log authors.models.length + ' authors'

        @layout.on "show", =>
          AL.ContentApp.Show.Controller.showTab('authors')
          @showTitle authors
          @listCatAuthors authors, 0

          @listDimensions()
          @listCategories("genre")

        # hold off rendering this
        App.authorsRegion.show @layout

    getLayoutView: ->
      new List.Layout

    showTitle: (authors) ->
      titleView = @getTitleView authors
      @layout.headerRegion.show titleView

    getTitleView: (authors) ->
      new List.Title
        collection: authors

    listDimensions: ->
      # console.log 'showDimensions()'
      dimensionsView = new List.Dimensions
      @layout.dimensionsRegion.show dimensionsView

    listCategories: (dim) ->
      App.request "category:entities", (categories) =>
        # console.log 'listCategories for: ', dim
        categoriesView = @getCategoriesView categories, dim
        # categoriesView.on 'childview:authors:filtered', (childView, model) ->
        #   console.log 'heard trigger', model
        # console.log categoriesView
        @layout.categoriesRegion.show categoriesView

    getCategoriesView: (categories, dim) ->
      new List.Categories
        collection: categories
        filter: (child, index, collection) ->
          child.get('dim') == dim

    listCatAuthors: (authors) ->
      authorsCatView = @getCatAuthorsView authors
      @layout.authorlistRegion.show authorsCatView

    getCatAuthorsView: (authors) ->
      new List.Authors
        collection: authors
