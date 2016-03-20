@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startContent: ->
      # build top-level frame for app
      @contentLayout = @getContentLayout()
      App.contentRegion.show @contentLayout
      if Cookies.get("al_splash") != "no-more"
        @openSplash()

      # render dropdown filter buttons & populate from db
      @listDimensions()
      if $("#ul_genre li").length == 0
        @dropdownCategories()

      @currentTab = "authors"
      # console.log '@currentTab', @currentTab

    openSplash: ->
      $("#splash_modal").removeClass("hidden")
      $("#splash_modal").dialog({
        modal: true,
        dialogClass: "splash-modal",
        # text: "<h1>Authorial London</h1><p>The City in the Lives and Works of its Writers<p>"+
        #   "<a href='#'>don't display again</a>"
        buttons: [
          {
            text: "Close",
            click: ->
              $( this ).dialog( "close" );
          }
        ],
        create: (e, ui) ->
          pane = $(this).dialog("widget").find(".ui-dialog-buttonpane")
          $("<label class='not-again'><input type='checkbox' onclick='setCookie()'/> Don't display on startup again</label>").prependTo(pane)

      })

    getContentLayout: ->
      new Show.ContentLayout

    # dimensions dropdowns ('genre, form, community, standing')
    listDimensions: ->
      # console.log 'showDimensions()'
      dimensionsView = new Show.Dimensions
      @contentLayout.dimensionsRegion.show dimensionsView

    # called from various places to manage tab state
    showTab: (tab)->
      ga('send', 'pageview', tab)
      # display home link in header and leave it there
      $("#home_link").removeClass("hidden")
      @activeTab = tab
      # console.log 'from '+ @currentTab + ' to ' + @activeTab + ' tab'

      # reset map on tab change if place markers are filters
      if App.request("places:count") < placesCount
        console.log 'the map has been filtered, resetting'
        App.vent.trigger("map:reset")

      $("#legend_list").html('')
      $("#legend_compare").addClass('hidden')

      $("#content_nav_region li").removeClass("active")
      $("#place_passages_region").addClass("hidden")

      $("#gallery_region").addClass("hidden")

      if tab == 'authors'
        # ensure dimensions dropdowns visible
        # App.vent.trigger("map:reset")
        $(".btn").disable(false)
        $("#dimensions_region").removeClass('hidden')

        AL.AuthorsApp.List.Controller.startAuthors()
        # Backbone.history.navigate('authors', true)
        @route = "authors"
        $("#authors_tab").addClass("active")
        $("#places_region").hide()
        $("#works_region").hide()
        $("#search_region").hide()
        $("#authors_region").fadeIn("slow")
        $("#b_comm").css('visibility','visible')
        $("#b_stand").css('visibility','visible')
        @currentTab = "authors"

      else if tab == 'places'
        # App.vent.trigger("map:reset")
        $("#dimensions_region").addClass('hidden')

        AL.PlacesApp.List.Controller.startPlaces(1)
        # Backbone.history.navigate('places', true)
        @route = "places"
        $("#places_tab").addClass("active")
        $("#authors_region").hide()
        $("#works_region").hide()
        $("#search_region").hide()
        $("#places_region").fadeIn("slow")
        @currentTab = "places"

      else if tab == 'works'
        # App.vent.trigger("map:reset")
        $(".btn").disable(false)
        $("#dimensions_region").removeClass('hidden')

        AL.WorksApp.List.Controller.startWorks()
        # Backbone.history.navigate('works', true)
        @route = "works"
        $("#works_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#search_region").hide()
        $("#works_region").fadeIn("slow")
        # hide author category buttons
        $("#b_comm").css('visibility','hidden')
        $("#b_stand").css('visibility','hidden')
        @currentTab = "works"

      else if tab == 'search'
        # console.log 'Show.Controller showTab(search)'
        $("#dimensions_region").addClass('hidden')

        AL.SearchApp.Show.Controller.startSearch()
        # Backbone.history.navigate('search', true)

        @route = "search"
        $("#search_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#works_region").hide()
        $("#search_region").show()
        @currentTab = "search"

      Backbone.history.navigate(@route)
      # Backbone.history.navigate(@route, true)

    # populate dropdowns from db
    dropdownCategories: ->
      App.request "category:entities", (categories) =>
        # console.log 'categories', categories
        for d in ['genre','form','community','standing']
          # console.log d
          dimcollection = categories.where({dimension: d})
          for c in dimcollection
            # console.log c
            $("#ul_"+d).append(
              "<li val="+c.attributes.category.category_id+">"+c.attributes.category.name+"</li>"
            )
