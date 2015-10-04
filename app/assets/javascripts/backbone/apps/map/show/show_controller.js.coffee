@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      @mapView = @getMapView()
      App.mapRegion.show @mapView


    setFilter: (key, evaluator) ->
      # console.log 'setFilter() ' + key, evaluator
      @mapView.setFilter key, evaluator

    clearFilters: ->
      @mapView.clearFilters()

    getMapView: ->
      new Show.Map

    # /**
    #  * Highlight a place site.
    #  *
    #  * @param {Number} id
    #  */
    onHighlightFeature: (id) ->
      this.view.highlightFeature(id);

    # /**
    #  * Unhighlight a place site.
    #  *
    #  * @param {Number} id
    #  */
    onUnhighlightFeature: (id) ->
      this.view.unhighlightFeature(id);

    # /**
    #  * Focus on a place site.
    #  *
    #  * @param {Number} id
    #  */
    onSelectFeature: (id) ->
      this.view.selectFeature(id);
