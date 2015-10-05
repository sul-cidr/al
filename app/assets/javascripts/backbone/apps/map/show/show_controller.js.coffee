@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      @mapView = @getMapView()
      App.mapRegion.show @mapView

    getMapView: ->
      new Show.Map

    setFilter: (key, evaluator) ->
      # console.log 'setFilter() ' + key, evaluator
      @mapView.setFilter key, evaluator

    clearFilters: ->
      @mapView.clearFilters()

    # /**
    #  * Highlight a place site.
    #  *
    #  * @param {Number} id
    #  */
    onHighlightFeature: (id) ->
      @mapView.highlightFeature(id);

    # /**
    #  * Unhighlight a place site.
    #  *
    #  * @param {Number} id
    #  */
    onUnhighlightFeature: (id) ->
      @mapView.unhighlightFeature(id);

    # /**
    #  * Focus on a place site.
    #  *
    #  * @param {Number} id
    #  */
    onSelectFeature: (id) ->
      @mapView.selectFeature(id);
