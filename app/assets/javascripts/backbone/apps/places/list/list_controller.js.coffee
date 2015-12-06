@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startPlaces: ->
      # set URL
      console.log 'PlacesApp.List startPlaces()'
      # Backbone.history.navigate("places")

      App.request "area:entities", (areas) =>
        # console.log areas
        @layout = @getLayoutView()

        @layout.on "show", =>
          AL.ContentApp.Show.Controller.showTab('places')
          @showSearchbox()
          @showNavmap()
          @listAreas areas

        # App.vent.trigger "areas:list", areas
        App.reqres.setHandler "areas:list", ->
          return areas

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

      areasView.on "childview:contact:show", (childView, model) ->
        # console.log model, model.get("id")
        App.vent.trigger "area:show", model

    getAreasView: (areas) ->
      new List.Areas
        collection: areas
        filter: (child, index, collection) ->
          child.get('area_type') == 'hood'


    getLayoutView: ->
      new List.Layout
