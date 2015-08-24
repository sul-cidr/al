@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	Show.Controller =
		
		showHeader: ->
			mapView = @getMapView()
			App.mapRegion.show mapView
		
		getHeaderView: ->
			new Show.Map

