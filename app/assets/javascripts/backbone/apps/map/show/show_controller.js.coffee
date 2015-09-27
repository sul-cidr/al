@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ()->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      mapView = @getMapView()
      # console.log 'mapView: ', mapView
      App.mapRegion.show mapView

    getMapView: (places) ->
      new Show.Map

    # /**
    #  * Highlight a place site.
    #  *
    #  * @param {Number} id
    #  */
    onHighlightPlace: (id) ->
      this.view.highlightPlace(id);

    # /**
    #  * Unhighlight a place site.
    #  *
    #  * @param {Number} id
    #  */
    onUnhighlightPlace: (id) ->
      this.view.unhighlightPlace(id);

    # /**
    #  * Focus on a place site.
    #  *
    #  * @param {Number} id
    #  */
    onSelectPlace: (id) ->
      this.view.selectPlace(id);
