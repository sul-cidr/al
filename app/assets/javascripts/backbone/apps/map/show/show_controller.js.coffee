@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ->
      # places = App.request "place:entities", (places) =>
      #   console.log places.length + ' places from controller: ', places
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
