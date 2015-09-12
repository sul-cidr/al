@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  List.Controller =

    startAuthors: ->
      App.request "author:entities", (authors) =>
        # console.log authors

        @layout = @getLayoutView()

        @layout.on "show", =>
          @showHeader authors
          @enumAuthors authors

        App.authorsRegion.show @layout   

    showHeader: (authors) ->
      headerView = @getHeaderView authors
      @layout.headerRegion.show headerView

    showDimensions: ->
      
    enumAuthors: (authors) ->
      authorsView = @getAuthorsView authors
      console.log authorsView
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
