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
      App.vent.trigger("map:reset")
      
      if tab == 'authors'
        # console.log 'Show.Controller showTab(authors)'
        # ensure dimensions dropdowns visible
        $("#dimensions_region").removeClass('hidden')

        Backbone.history.navigate('authors')
        @route = "authors"
        $("#authors_tab").addClass("active")
        $("#places_region").hide()
        $("#works_region").hide()
        $("#search_region").hide()
        $("#authors_region").fadeIn("slow")

      else if tab == 'places'
        # console.log 'Show.Controller showTab(places)'
        # hide dimensions dropdowns
        $("#dimensions_region").addClass('hidden')

        if $("#places_region").html() == ''
          Backbone.history.navigate('places', true)
          # AL.PlacesApp.List.Controller.startPlaces()
        @route = "places"
        $("#places_tab").addClass("active")
        $("#authors_region").hide()
        $("#works_region").hide()
        $("#search_region").hide()
        $("#places_region").show()

      else if tab == 'works'
        # console.log 'Show.Controller showTab(works)'
        # ensure dimensions dropdowns visible
        $("#dimensions_region").removeClass('hidden')

        if $("#works_region").html() == ''
          Backbone.history.navigate('works', true)
        #   AL.WorksApp.List.Controller.startWorks()
        @route = "works"
        $("#works_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#search_region").hide()
        $("#works_region").fadeIn("slow")

      else if tab == 'search'
        # console.log 'Show.Controller showTab(search)'
        $("#dimensions_region").addClass('hidden')

        if $("#search_region").html() == ''
          Backbone.history.navigate('search', true)
        @route = "search"
        $("#search_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#works_region").hide()
        $("#search_region").show()

      Backbone.history.navigate(@route)
      # Backbone.history.navigate(@route, true)
