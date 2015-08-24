@AL = do (Backbone, Marionette) ->
	
	App = new Marionette.Application
	
	App.addRegions
		headerRegion: "#header-region"
		mapRegion: "#map-region"
		authorsRegion: "#authors-region"
		placesRegion: "#places-region"
		mainRegion: "#main-region"
		footerRegion: "#footer-region"
	
	App.addInitializer ->
		App.module("HeaderApp").start()
		App.module("AuthorsApp").start()
		App.module("PlacesApp").start()
	
	App.on "initialize:after", ->
		if Backbone.history
			Backbone.history.start()
	
	App
