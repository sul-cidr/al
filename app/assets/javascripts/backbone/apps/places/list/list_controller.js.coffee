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

      areasView.on "childview:contact:show", (childView, model) ->
        # console.log model, model.get("id")
        App.vent.trigger "area:show", model

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
      # AL.vent.trigger("map:reset")
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
