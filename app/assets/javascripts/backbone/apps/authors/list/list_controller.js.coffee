@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startAuthors: ->
      App.request "author:entities", (authors) =>
        # console.log 'authors: ', authors

        @layout = @getLayoutView()
        # console.log @layout

        @layout.on "show", =>
          @showHeader authors
          @listAuthors authors, 'all'
          @listDimensions()
          @listCategories()

        App.authorsRegion.show @layout

    showHeader: (authors) ->
      headerView = @getHeaderView authors
      @layout.headerRegion.show headerView

    listDimensions: ->
      # console.log 'showDimensions()'
      dimensionsView = new List.Dimensions
      @layout.dimensionsRegion.show dimensionsView

    listCategories: ->
      App.request "category:entities", (categories) =>
        # console.log 'categories: ', categories
        categoriesView = @getCategoriesView categories
        @layout.categoriesRegion.show categoriesView

    getCategoriesView: (categories) ->
      new List.Categories
        collection: categories

    showAuthor: (author) ->
      console.log 'showAuthor()',author
      # swaps out authors for single author
      authorView = @getAuthorView author
      # console.log authorView
      App.authorsRegion.show authorView

    getAuthorView: (author) ->
      # console.log author
      new List.AuthorLayout ({
        model: author
      })

    listAuthors: (authors, category) ->
      console.log category
      # authorsCatView = @getAuthorsCatView category
      authorsView = @getAuthorsView authors
      @layout.authorlistRegion.show authorsView

    # experiment: getting authors from rails genre.authors e.g.
    # getAuthorsCatView: (cat) ->
    #   new List.CategoryAuthors
        # collection: categories.authors

    getAuthorsView: (authors) ->
      new List.Authors
        collection: authors

    getHeaderView: (authors) ->
      new List.Header
        collection: authors

    getLayoutView: ->
      new List.Layout
