@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  List.Controller =

    listCats: ->
      App.request "category:entities", (categories) =>
        # console.log 'categories: ', categories
        categoriesView = @getCategoriesView categories
        @layout.categoriesRegion.show categoriesView

    startAuthors: ->
      App.request "author:entities", (authors) =>
        # console.log 'authors: ', authors

        @layout = @getLayoutView()
        # console.log @layout

        @layout.on "show", =>
          @showHeader authors
          @enumAuthors authors
          @showDimensions()
          @listCats()

        App.authorsRegion.show @layout  

    showHeader: (authors) ->
      headerView = @getHeaderView authors
      @layout.headerRegion.show headerView

    showDimensions: ->
      # console.log 'showDimensions()'
      dimensionsView = new List.Dimensions
      @layout.dimensionsRegion.show dimensionsView

    showCategories: (categories) ->
      # console.log 'showCategories() ', categories
      categoriesView = @getCategoriesView categories
      # console.log categoriesView
      @layout.categoriesRegion.show categoriesView

    getCategoriesView: (categories) ->
      new List.Categories
        collection: categories

    enumAuthors: (authors) ->
      authorsView = @getAuthorsView authors
      # console.log authorsView
      @layout.authorlistRegion.show authorsView

    getAuthorsView: (authors) ->
      new List.Authors
        collection: authors

    getHeaderView: (authors) ->
      new List.Header
        collection: authors

    getLayoutView: ->
      new List.Layout
    
    listAuthors: ->   
      # dummy needed for some unknown reason
