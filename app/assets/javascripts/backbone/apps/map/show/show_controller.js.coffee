@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      @mapView = @getMapView()

      # hold off rendering
      App.mapRegion.show @mapView
      # $("#spin_map").addClass('hidden')

    getMapView: ->
      new Show.Map

    swapBase: (id) ->
      @mapView.swapBase id

    filterPlaces: (filter) ->
      # console.log 'filterPlaces', filter
      @mapView.renderPlaces(filter)

    renderOneAuthor: (params) ->
      # console.log 'renderOneAuthor() sending renderPlaces()', params
      @mapView.renderPlaces(params)

    dropOneAuthor: (params) ->
      console.log 'dropOneAuthor() sending removePlaces():', params
      @mapView.removePlaces(params)

    setFilter: (key, evaluator, counter) ->
      # console.log 'Map.Show.Controller.setFilter() ' + key
      @mapView.setFilter key, evaluator

    clearFilters: (keepzoom)->
      @mapView.renderPlaces()
      # @mapView.clearFilters(keepzoom)

    zoomTo: (what, area) ->
      @mapView.zoomTo what, area

    filterByArea: (type, b) ->
      window.counter = 0
      # console.log "bounds to turf from hoods:", b
      @setFilter 'area', (placeref) ->
      # MapApp.Show.Controller.setFilter 'area', (placeref) ->
        counter += 1
        # console.log turf.point( wellknown(placeref.attributes.geom_wkt).coordinates )

        # b is a hood voronoi polygon geojson object a
        turf.inside( turf.point(wellknown(placeref.get("geom_wkt")).coordinates), b )
        # b is a viewport

    # /**
    #  * Unhighlight all; part of map:reset
    #  */
    unhighlightAll: ->
      @mapView.unhighlightAll()

    # /**
    # from on map_app "placeref:click"
    # Go to view
    # */
    onClickPlaceref: (prid) ->
      @mapView.clickPlaceref(prid);

    # /**
    #  * Highlight a place.
    #  */
    onHighlightFeature: (prid) ->
      @mapView.highlightFeature(prid);

    # /**
    #  * Unhighlight a place.
    #  */
    onUnhighlightFeature: (prid) ->
      @mapView.unhighlightFeature(prid);

    # /**
    #  * Focus on a place.
    #  */
    onSelectFeature: (what, id) ->
      @mapView.selectFeature(what, id);

      # TODO: rig this
    showOnePassage: (passage_id) ->
      # retrieve single passage
      $("#place_passages_region").removeClass('hidden')
      App.request "passage:place", passage_id, (place_passages) =>
        # if App.authorContentRegion.$el.length > 0
        #   App.authorContentRegion.reset()
        window.placepassage = place_passages
        placePassageView = @getPlacePassageView place_passages

        App.placePassagesRegion.show placePassageView
        App.placePassagesRegion.$el.fadeIn("slow")
        #
        # $(".passages-places h4").html(authHash[authid])

    getPlacePassageView: (place_passages) ->
      new AL.PlacesApp.Show.PlacePassages ({
        collection: place_passages
        # viewComparator: "passage_id"
        className: 'passages-places'
      })
