@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      @mapView = @getMapView()

      # hold off rendering
      App.mapRegion.show @mapView

    getMapView: ->
      new Show.Map

    setFilter: (key, evaluator, counter) ->
      # console.log 'Map.Show.Controller.setFilter() ' + key
      @mapView.setFilter key, evaluator

    clearFilters: ->
      @mapView.clearFilters()

    zoomTo: (what, area) ->
      @mapView.zoomTo what, area


    filterByArea: (type, b) ->
      window.counter = 0
      console.log "bounds to turf from hoods:", b
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
    #  * Click a place in text.
    #  */
    onClickPlaceref: (what, id) ->
      @mapView.clickPlaceref(what, id);

    # /**
    #  * Highlight a place.
    #  */
    onHighlightFeature: (what, id) ->
      @mapView.highlightFeature(what, id);

    # /**
    #  * Unhighlight a place.
    #  */
    onUnhighlightFeature: (what, id) ->
      @mapView.unhighlightFeature(what, id);

    # /**
    #  * Focus on a place.
    #  */
    onSelectFeature: (what, id) ->
      @mapView.selectFeature(what, id);

      # TODO: rig this
    showOnePassage: (passage_id) ->
      # retrieve single passage
      App.request "passage:place", passage_id, (place_passages) =>
        # if App.authorContentRegion.$el.length > 0
        #   App.authorContentRegion.reset()
        window.placepassage = place_passages
        placePassageView = @getPlacePassageView place_passages

        App.placePassagesRegion.show placePassageView
        App.placePassagesRegion.$el.fadeIn("slow")
        #
        # $(".passages-places h4").html(authhash[authid])

    getPlacePassageView: (place_passages) ->
      new AL.PlacesApp.Show.PlacePassages ({
        collection: place_passages
        # viewComparator: "passage_id"
        className: 'passages-places'
      })
