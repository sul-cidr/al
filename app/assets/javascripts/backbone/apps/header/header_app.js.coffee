@AL.module "HeaderApp", (HeaderApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	API =
		showHeader: ->
			HeaderApp.Show.Controller.showHeader()
	
	HeaderApp.on "start", ->
		# console.log "started HeaderApp"
		API.showHeader()