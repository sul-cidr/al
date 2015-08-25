@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	Show.Controller =
		
		showPlaces: ->
			placesView = @getPlacesView()
			App.placesRegion.show placesView
		
		getPlacesView: ->
			new Show.Places

