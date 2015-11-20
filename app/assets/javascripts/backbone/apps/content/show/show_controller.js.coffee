@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startContent: ->
      # build top-level frame for app
      @contentLayout = @getContentLayout()
      App.contentRegion.show @contentLayout

      # render dropdown filter buttons & populate from db
      @listDimensions()
      @dropdownCategories()

    getContentLayout: ->
      new Show.ContentLayout

    # TODO: refactor passages for authors, places, works

    # dimensions dropdowns ('genre, form, community, standing')
    listDimensions: ->
      # console.log 'showDimensions()'
      dimensionsView = new Show.Dimensions
      @contentLayout.dimensionsRegion.show dimensionsView

    # populate dropdowns from db
    dropdownCategories: ->
      App.request "category:entities", (categories) =>
        # console.log categories
        for d in ['genre','form','community','standing']
           dimcollection = categories.where({dim: d});
           for c in dimcollection
             $("#ul_"+d).append(
              "<li val="+c.attributes.id+">"+c.attributes.name+
              "</li>"
             )

    # called from various places to manage tab state
    showTab: (tab)->
      # $(".header-left").removeClass("hidden")
      $("#content_nav_region li").removeClass("active")
      $("#place_passages_region").fadeOut()

      if tab == 'authors'
        # ensure dimensions dropdowns visible
        $("#dimensions_region").show()

        @route = "authors"
        $("#authors_tab").addClass("active")
        $("#places_region").hide()
        $("#works_region").hide()
        $("#authors_region").fadeIn("slow")

      else if tab == 'places'
        # hide dimensions dropdowns
        $("#dimensions_region").hide()
        
        if $("#places_region").html() == ''
          $(".header-left").removeClass("hidden")
          AL.PlacesApp.List.Controller.startPlaces()
        @route = "places"
        $("#places_tab").addClass("active")
        $("#authors_region").hide()
        $("#works_region").hide()
        $("#places_region").show()

      else if tab == 'works'
        # ensure dimensions dropdowns visible
        $("#dimensions_region").show()

        if $("#works_region").html() == ''
          $(".header-left").removeClass("hidden")
          AL.WorksApp.List.Controller.startWorks()
        @route = "works"
        $("#works_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#works_region").fadeIn("slow")

      Backbone.history.navigate(@route, true)

    # startAuthors: ->
      # get a view and show in authorsRegion
      # console.log 'Show.Controller.startAuthors'

    # startPlaces: ->
      # get a view and show in placesRegion
      # console.log 'Show.Controller.startPlaces'
