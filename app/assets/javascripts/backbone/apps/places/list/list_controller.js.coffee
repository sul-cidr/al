@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startPlaces: ->
      # console.log 'PlacesApp.List startPlaces()'

      @layout = @getLayoutView()

      @layout.on "show", =>
        $("#spin_authors").addClass('hidden')
        AL.ContentApp.Show.Controller.showTab('places')
        @showSearchbox()
        @showNavmap()
        @listAreas(1)

      App.placesRegion.show @layout

    listAreas: (borough) ->
      $("#places_navmap h4").html('Neighborhoods in and around <span class="red">'+
        boroughHash[borough]+'</span')
      hoodArray = boroughHoods[borough]
      # console.log 'listAreas(), borough: '+borough, hoodArray
      # window.areas = App.reqres.getHandler("areas:active")()
      window.filteredAreas = areas.filter((area) ->
        area.get('area_id') in hoodArray
      )
      # new collection from models
      boroughCollection = new Backbone.Collection(filteredAreas);
      # view with collection
      areasView = @getAreasView boroughCollection
      # console.log 'boroughCollection ', boroughCollection
      @layout.arealistRegion.show areasView

    getAreasView: (boroughCollection) ->
      new List.Areas
        collection: boroughCollection
        filter: (child, index, collection) ->
          child.get('area_type') == 'hood'

    getLayoutView: ->
      new List.Layout

    showSearchbox: ->
      App.request "placeref:entities", {}, (placerefs) =>
        console.log 'showSearchbox', placerefs
        searchboxView = new List.Searchbox
          collection: placerefs
        @layout.searchboxRegion.show searchboxView

    showNavmap: ->
      navmapView = new List.Navmap
      # console.log navmapView
      @layout.navmapRegion.show navmapView
      # put map in div with area selected
      $("#keymap").html( makeKeymap(1) )
