@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startPlaces: ->
      # set URL
      console.log 'PlacesApp.List startPlaces()'
      # Backbone.history.navigate("places")

      # area collection already loaded by map
      areas = AL.reqres.getHandler("areas:active")()
      # App.request "area:entities", (areas) =>

      @layout = @getLayoutView()

      @layout.on "show", =>
        AL.ContentApp.Show.Controller.showTab('places')
        @showSearchbox()
        @showNavmap()
        @listAreas areas

        # App.vent.trigger "areas:list", areas
        # App.reqres.setHandler "areas:list", ->
        #   return areas

        # hold off rendering
      App.placesRegion.show @layout

    showSearchbox: ->
      App.request "placeref:entities", (placerefs) =>
        searchboxView = new List.Searchbox
          collection: placerefs
        @layout.searchboxRegion.show searchboxView


    showNavmap: ->
      navmapView = new List.Navmap
      # console.log navmapView
      @layout.navmapRegion.show navmapView
      # put map in div with area selected
      $("#keymap").html( makeKeymap(1) )

    listAreas: (areas) ->
      areasView = @getAreasView areas
      @layout.arealistRegion.show areasView


    getAreasView: (areas) ->
      new List.Areas
        collection: areas
        filter: (child, index, collection) ->
          child.get('area_type') == 'hood'


    getLayoutView: ->
      new List.Layout
