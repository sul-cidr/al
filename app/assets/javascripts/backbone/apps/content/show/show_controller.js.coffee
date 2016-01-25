@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startContent: ->
      # build top-level frame for app
      @contentLayout = @getContentLayout()
      App.contentRegion.show @contentLayout

      @listDimensions()
      # @contentLayout.on "show", =>
      # render dropdown filter buttons & populate from db
      if $("#ul_genre li").length == 0
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
    # OLD method
    dropdownCategories: ->
      App.request "category:entities", (categories) =>
        # console.log categories
        for d in ['genre','form','community','standing']
          # console.log d
          dimcollection = categories.where({dimension: d})
          for c in dimcollection
            # console.log c
            $("#ul_"+d).append(
              "<li val="+c.attributes.category.category_id+">"+c.attributes.category.name+"</li>"
            )

    # called from various places to manage tab state
    showTab: (tab)->
      # zap legend if any tab action is taken...I think
      # TODO: reset map when changing tab
      # if Object.keys(places._layers).length < 600
      # if map.getZoom() != 12 # || Object.keys(places._layers).length < 600
      #   App.vent.trigger("map:reset")

      $("#legend_list").html('')
      $("#legend").addClass('hidden')

      $("#content_nav_region li").removeClass("active")
      $("#place_passages_region").fadeOut()

      if tab == 'authors'
        # console.log 'Show.Controller showTab(authors)'
        # ensure dimensions dropdowns visible
        # App.vent.trigger("map:reset")
        $(".btn").disable(false)
        $("#dimensions_region").removeClass('hidden')

        Backbone.history.navigate('authors', true)
        @route = "authors"
        $("#authors_tab").addClass("active")
        $("#places_region").hide()
        $("#works_region").hide()
        $("#search_region").hide()
        $("#authors_region").fadeIn("slow")
        $("#b_comm").css('visibility','visible')
        $("#b_stand").css('visibility','visible')

      else if tab == 'places'
        # App.vent.trigger("map:reset")
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
        # App.vent.trigger("map:reset")
        $(".btn").disable(false)
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
        $("#b_comm").css('visibility','hidden')
        $("#b_stand").css('visibility','hidden')

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
