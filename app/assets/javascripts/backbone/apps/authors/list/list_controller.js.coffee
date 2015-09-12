@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  List.Controller =

    listAuthors: ->
      App.request "author:entities", (authors) =>
        # console.log authors

        @layout = @getLayoutView()

        @layout.on "show", =>
          @showHeader authors
          @showAuthors authors

        App.authorsRegion.show @layout      

    showHeader: (authors) ->
      headerView = @getHeaderView authors
      @layout.headerRegion.show headerView

    showAuthors: (authors) ->
      authorsView = @getAuthorsView authors
      # console.log authorsView
      @layout.authorsRegion.show authorsView

    getAuthorsView: (authors) ->
      new List.Authors
        collection: authors

    getHeaderView: (authors) ->
      new List.Header
        collection: authors

    getLayoutView: ->
      new List.Layout
    

      # authorsCollection = new List.Collection

      # authorsCollection.fetch()

      # authorsView = new List.AuthorsView({
      #   collection: authorsCollection
      # })

      # App.authorsRegion.show authorsView 

