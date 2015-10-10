@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startPlaces: ->
    #
    # get areas here, used to aggregate & navigate places/placerefs
    #
      App.request "area:entities", (areas) =>

        @layout = @getLayoutView()

        @layout.on "show", =>
          @showTitle()
          @showNavmap()
          @listAreas areas

        # App.vent.trigger "areas:list", areas
        App.reqres.setHandler "areas:list", ->
          return areas
        App.placesRegion.show @layout

    listAreas: (areas) ->
      areasView = @getAreasView areas
      @layout.arealistRegion.show areasView

    getAreasView: (areas) ->
      new List.Areas
        collection: areas
        filter: (child, index, collection) ->
          child.get('area_type') == 'borough'

    showTitle: ->
      titleView = new List.Title
      # console.log titleView
      @layout.titleRegion.show titleView

    showNavmap: ->
      navmapView = new List.Navmap
      # console.log navmapView
      @layout.navmapRegion.show navmapView

    getLayoutView: ->
      new List.Layout

    togglePanel: ->
      xpos = ($(window).width() - 350) - $("#places-region").offset().left
      if xpos == 0
        # places panel is open
        $("#places-region").animate { 'right': -($("#places-region").width() - 15) }, 500
        App.vent.trigger("places-panel:close")
        $(".toggle-places").removeClass("hidden")
      else if $("#places-region").offset().left > $(window).width() - 350
        # places panel is closed
        $("#places-region").animate { 'right': 0}, 500
        App.vent.trigger("places-panel:open")
        $(".toggle-places").addClass("hidden")
    #
    ## places are geometries to be mapped
    ## handled from map
    #
    # listPlaces: ->
    #   # not listing them all anywhere, just getting data for map module
    #   App.request "place:entities", (places) =>
    #     window.mapdata = places
    #     # console.log mapdata
    #   # placesView = @getPlacesView places
    #   # @layout.placesRegion.show placesView
    #   # console.log 'placesView', placesView
    #
    # getPlacesView: (places) ->
    #   new List.Places
    #     collection: places
    #     # filtered in view definition
