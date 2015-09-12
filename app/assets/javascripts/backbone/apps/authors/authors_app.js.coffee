@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
	# @startWithParent = false

##
	class AuthorsApp.Router extends Marionette.AppRouter
		appRoutes:
			"authors ": "listAuthors"
			"author": "showAuthor"
##

	API =
		showAuthor: ->
			AuthorsApp.Show.Controller.showAuthor()

		listAuthors: ->
			AuthorsApp.List.Controller.listAuthors()

##
	App.addInitializer ->
		new AuthorsApp.Router
			controller: API
		#API.showAuthors()
		AuthorsApp.List.Controller.startAuthors()
##
	
	# AuthorsApp.on "start", ->
	# 	API.listAuthors()
	# 	# API.showAuthor()