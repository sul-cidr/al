@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	API =

		showPlaces: ->
			PlacesApp.Show.Controller.showPlaces()
	
	PlacesApp.on "start", ->
		# API.listPlaces()
		API.showPlaces()