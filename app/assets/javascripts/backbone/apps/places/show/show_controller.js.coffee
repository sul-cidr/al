@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	Show.Controller =

    showArea: (id) ->
      # console.log arguments.callee.caller.toString()
      console.log 'Show.Controller.showArea()', id

		showPlaces: ->
			placesView = @getPlacesView()
			App.placesRegion.show placesView

		getPlacesView: ->
			new Show.Places
