@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startContent: ->
      @contentLayout = @getContentLayout()
      # start with authors
      # if $("#authors_region").html() == ''
      #   AL.AuthorsApp.List.Controller.startAuthors()
      # AL.PlacesApp.List.Controller.startPlaces()
      # AL.WorksApp.List.Controller.startWorks()
      App.contentRegion.show @contentLayout

    getContent: ->
      new Show.ContentLayout

    getContentLayout: ->
      new Show.ContentLayout

    # TODO: refactor passages for authors, places, works


    showTab: (tab)->
      # $(".header-left").removeClass("hidden")
      $("#content_nav_region li").removeClass("active")
      $("#place_passages_region").fadeOut()

      if tab == 'authors'
        @route = "authors"
        $("#authors_tab").addClass("active")
        $("#places_region").hide()
        $("#works_region").hide()
        $("#authors_region").fadeIn("slow")

      else if tab == 'places'
        if $("#places_region").html() == ''
          $(".header-left").removeClass("hidden")
          AL.PlacesApp.List.Controller.startPlaces()
        @route = "places"
        $("#places_tab").addClass("active")
        $("#authors_region").hide()
        $("#works_region").hide()
        $("#places_region").show()

      else if tab == 'works'
        if $("#works_region").html() == ''
          $(".header-left").removeClass("hidden")
          AL.WorksApp.List.Controller.startWorks()
        @route = "works"
        $("#works_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#works_region").fadeIn("slow")

      Backbone.history.navigate(@route, true)

    startAuthors: ->
      # get a view and show in authorsRegion
      # console.log 'Show.Controller.startAuthors'

    startPlaces: ->
      # get a view and show in placesRegion
      # console.log 'Show.Controller.startPlaces'
