@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	API =

		# TODO: Marionette LayoutView
		# listPlaces: ->
		# 	PlacesApp.List.Controller.listPlaces()

		showPlaces: ->
			PlacesApp.Show.Controller.showPlaces()
	
	PlacesApp.on "start", ->
		# API.listPlaces()
		API.showPlaces()