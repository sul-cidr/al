@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	Show.Controller =
		
		showMap: ->
			mapView = @getMapView()
			App.mapRegion.show mapView
		
		getMapView: ->
			new Show.Map

