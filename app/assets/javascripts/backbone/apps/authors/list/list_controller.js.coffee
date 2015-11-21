@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startAuthors: ->
      # set URL
      Backbone.history.navigate("authors")

      # start with all (cat 0); filtered in the app
      App.request "authors:category", 0, (authors) =>
        @layout = @getLayoutView()
        # console.log authors.models.length + ' authors'

        @layout.on "show", =>
          AL.ContentApp.Show.Controller.showTab('authors')
          # @showTitle authors
          @listCatAuthors authors

        #
        App.authorsRegion.show @layout

    getLayoutView: ->
      new List.Layout

    listCatAuthors: (authors) ->
      authorsCatView = @getCatAuthorsView authors
      @layout.authorlistRegion.show authorsCatView

    getCatAuthorsView: (authors) ->
      new List.Authors
        collection: authors

    showTitle: (authors) ->
      titleView = @getTitleView authors
      @layout.headerRegion.show titleView

    getTitleView: (authors) ->
      new List.Title
        collection: authors
