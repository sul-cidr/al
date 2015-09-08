@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false
	
	API =
		showAuthor: ->
			AuthorsApp.Show.Controller.showAuthor()

		listAuthors: ->
			AuthorsApp.List.Controller.listAuthors()
	
	AuthorsApp.on "start", ->
		API.listAuthors()
		# API.showAuthor()