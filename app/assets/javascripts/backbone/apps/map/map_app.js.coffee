@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	API =
		showMap: ->
			MapApp.Show.Controller.showMap()
	
	MapApp.on "start", ->
		API.showMap()