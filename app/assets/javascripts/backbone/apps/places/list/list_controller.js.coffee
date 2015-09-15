@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  List.Controller =

    startPlaces: ->
      App.request "area:entities", (areas) =>
        # console.log areas

        @layout = @getLayoutView()

        @layout.on "show", =>
          @showHeader areas
          @listAreas areas

        App.placesRegion.show @layout      
   
    #
    # areas are used to aggregate & navigate places/placerefs
    #
    listAreas: (areas) ->
      areasView = @getAreasView areas
      # console.log areas
      # console.log 'areasView', areasView
      @layout.placesRegion.show areasView

    getAreasView: (areas) ->
      new List.Areas
        collection: areas
        filter: (child, index, collection) ->
          child.get('area_type') == 'borough'

    #
    ## places are geometries to be mapped
    #
    listPlaces: (places) ->
      placesView = @getPlacesView places
      # console.log 'placesView', placesView
      @layout.placesRegion.show placesView

    getPlacesView: (places) ->
      new List.Places
        collection: places
        # filtered in view definition


    showHeader: (places) ->
      # headerView = @getHeaderView places
      # for now, a static map in _places.jst.eco
      # @layout.headerRegion.show headerView

    getHeaderView: (places) ->
      new List.Header
        collection: places

    getLayoutView: ->
      new List.Layout
