@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	Show.Controller =
		
		showMap: ->
			mapView = @getMapView()
      # console.log mapView
			App.mapRegion.show mapView
		
		getMapView: ->
			new Show.Map

