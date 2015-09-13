@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
	# @startWithParent = false

	class AuthorsApp.Router extends Marionette.AppRouter
		appRoutes:
			"authors": "listAuthors"
			"author": "showAuthor"
			# "categories": "showCategories"

	API =
		showAuthor: ->
			AuthorsApp.Show.Controller.showAuthor()

		listAuthors: ->
			# dummy needed for some unknown reason

		showCategories: ->


	App.addInitializer ->
		new AuthorsApp.Router
			controller: API
		# API.startAuthors()
		AuthorsApp.List.Controller.startAuthors()
