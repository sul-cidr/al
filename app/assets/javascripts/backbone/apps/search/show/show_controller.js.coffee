@AL.module 'SearchApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startSearch: ->
      # console.log 'Show.Controller.startSearch()'
      # set URL
      Backbone.history.navigate("search")
      @layout = @getLayoutView()
      # console.log '@layout', @layout

      @layout.on "show", =>
        AL.ContentApp.Show.Controller.showTab('search')

      App.searchRegion.show @layout

    getLayoutView: ->
      new Show.Layout

    searchPassages: (q) ->
      # console.log 'search_app Show.Controller.searchPassages()', q
      App.request "passages:search", q, (results) =>
        window.searchresults = results
        if results.length > 0
          resultsView = @getResultsView results
          @layout.resultsRegion.show resultsView
          $(".clear-search").removeClass('hidden')
        else
          $(".passagelist").html('<p>Sorry, no results...</p>')

      $(".search-passages h4").html('Mentions of <b>'+q+'</b>')

    getResultsView: (results) ->
      new Show.SearchResults ({
        collection: results
        viewComparator: "passage_id"
        className: 'passages-search'
      })
