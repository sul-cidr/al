@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startContent: ->
      @contentLayout = @getContentLayout()
      # start with authors
      # AL.AuthorsApp.List.Controller.startAuthors()
      App.contentRegion.show @contentLayout

    getContent: ->
      new Show.ContentLayout

    getContentLayout: ->
      new Show.ContentLayout

    showTab: (tab)->
      console.log 'showTab(): ',tab
      $("#content_nav_region li").removeClass("active")

      if tab == 'authors'
        @route = "authors"
        $("#authors_tab").addClass("active")
        $("#places_region").hide()
        $("#works_region").hide()
        $("#authors_region").fadeIn("slow")

      else if tab == 'places'
        @route = "places"
        $("#places_tab").addClass("active")
        $("#authors_region").hide()
        $("#works_region").hide()
        $("#places_region").show()

      else if tab == 'works'
        @route = "works"
        $("#works_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#works_region").fadeIn("slow")

      Backbone.history.navigate(@route)

    startAuthors: ->
      # get a view and show in authorsRegion
      # console.log 'Show.Controller.startAuthors'

    startPlaces: ->
      # get a view and show in placesRegion
      # console.log 'Show.Controller.startPlaces'
