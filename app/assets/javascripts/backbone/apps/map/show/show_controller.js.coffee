@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      @mapView = @getMapView()

      # hold off rendering
      App.mapRegion.show @mapView

    getMapView: ->
      new Show.Map

    setFilter: (key, evaluator) ->
      # console.log 'Map.Show.Controller.setFilter() ' + key
      @mapView.setFilter key, evaluator

    clearFilters: ->
      @mapView.clearFilters()

    zoomTo: (what, area) ->
      # console.log 'zoomTo <'+what+'> fired from controller'
      @mapView.zoomTo what, area

    # /**
    #  * Unhighlight all; part of map:reset
    #  */
    unhighlightAll: ->
      @mapView.unhighlightAll()

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
