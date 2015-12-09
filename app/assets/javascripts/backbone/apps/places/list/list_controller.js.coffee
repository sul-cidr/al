@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startPlaces: ->
      # set URL
      console.log 'PlacesApp.List startPlaces()'
      # Backbone.history.navigate("places")

      # get area collection already loaded by map
      # window.areas = AL.reqres.getHandler("areas:active")()
      # App.request "area:entities", (areas) =>

      @layout = @getLayoutView()

      @layout.on "show", =>
        AL.ContentApp.Show.Controller.showTab('places')
        @showSearchbox()
        @showNavmap()
        @listAreas(13)

        # hold off rendering
      App.placesRegion.show @layout

    listAreas: (borough) ->
      hoodArray = boroughHoods[borough]
      console.log borough+': '+hoodArray
    # listAreas: (areas, borough) ->
      # TODO: get all 115 areas somehow
      window.areas = AL.reqres.getHandler("areas:active")()
      filteredAreas = areas.filter((area) ->
        area.get('id') in hoodArray
      )
      # new collection from models
      boroughCollection = new Backbone.Collection(filteredAreas);
      # view with collection
      areasView = @getAreasView boroughCollection

      console.log 'boroughCollection ', boroughCollection
      @layout.arealistRegion.show areasView

    getAreasView: (boroughCollection) ->
      new List.Areas
        collection: boroughCollection
        filter: (child, index, collection) ->
          child.get('area_type') == 'hood'

    getLayoutView: ->
      new List.Layout

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
