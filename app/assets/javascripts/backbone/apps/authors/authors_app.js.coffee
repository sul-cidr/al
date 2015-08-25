@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	API =
		showAuthors: ->
			AuthorsApp.Show.Controller.showAuthors()
	
	AuthorsApp.on "start", ->
		API.showAuthors()