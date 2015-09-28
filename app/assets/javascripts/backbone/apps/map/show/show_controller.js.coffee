@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showMap: ->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      mapView = @getMapView()
      App.mapRegion.show mapView

    updateMap: (placerefs) ->
      # console.log 'MapApp.Show.Controller.showMap()', authors
      mapView = @getMapView()
      # mapView.initMap(placerefs)
      mapView.updateMap(placerefs)
      # console.log 'mapView: ', mapView
      App.mapRegion.show mapView

    getMapView: ->
      new Show.Map

    refreshMap: (what, model)->
      console.log 'API.refresh() --> Show.Controller.refreshMap', what, model
      id = model.attributes.author_id
      App.request "placerefs:author", id, (placerefs) =>
        console.log placerefs

    getRefreshMapView: (places) ->
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
