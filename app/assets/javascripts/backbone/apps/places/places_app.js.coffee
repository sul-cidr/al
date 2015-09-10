@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
	#@startWithParent = false
	
	##
	# places have geometry; areas are a subset of places, incl.
	# boroughs/wards/neighborhoods
	# place references in text refer to places
	# navigation can drill down in places, some of which
	# are the object of placerefs

	class PlacesApp.Router extends Marionette.AppRouter
		appRoutes:
			"places ": "listPlaces"
			# "place/??": "showPlace"

	API =
		# one or the other
		# listPlaces: ->
		# 	PlacesApp.List.Controller.listPlaces()
		listPlaces: ->
			PlacesApp.Show.Controller.showPlaces()

		# # ?? differentiate areas (neighborhoods/districts)?
		# listAreas: ->
		# 	console.log 'show places tagged "area"'

		# # detail page for a place (or buffer around place) via search
		# showPlace: ->
			
		# # detail page for an area (neighborhood/district)
		# showArea: ->
			# 	

	App.addInitializer ->
		new PlacesApp.Router
			controller: API
		API.listPlaces()
