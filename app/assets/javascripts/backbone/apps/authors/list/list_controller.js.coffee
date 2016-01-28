@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startAuthors: ->
      # zap legend contents and hide
      $("#legend_list").html('')
      $("#legend_compare").addClass('hidden')
      $("#legend_base").removeClass('hidden')

      $(".btn").disable(true)
      # App.vent.trigger "map:reset"
      # get all
      App.request "author:entities", (authors) =>
        @layout = @getLayoutView()
        # console.log authors.models.length + ' authors'

        @layout.on "show", =>
          AL.ContentApp.Show.Controller.showTab('authors')
          # @showTitle authors
          @listCatAuthors authors
          $("#spin_authors").addClass('hidden')

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
