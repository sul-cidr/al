@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  List.Controller =

    startAuthors: ->

      App.request "author:entities", (authors) =>
        # console.log authors

        @layout = @getLayoutView()
        # console.log @layout

        @layout.on "show", =>
          @showHeader authors
          @enumAuthors authors
          @showDimensions()
          @showCategories()

        App.authorsRegion.show @layout  

    showHeader: (authors) ->
      headerView = @getHeaderView authors
      @layout.headerRegion.show headerView

    showDimensions: ->
      console.log 'showDimensions()'
      dimensionsView = new List.Dimensions
      @layout.dimensionsRegion.show dimensionsView

    showCategories: ->
      console.log 'showCategories() - how?'
      categoriesView = new List.Categories #@getCategoriesView
      @layout.categoriesRegion.show categoriesView

    getCategoriesView: ->
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
