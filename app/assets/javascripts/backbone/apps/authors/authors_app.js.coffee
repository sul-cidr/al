@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
	# @startWithParent = false

	class AuthorsApp.Router extends Marionette.AppRouter
		appRoutes:
			"authors": "listAuthors"
			"author": "showAuthor"
			"dimensions": "listDimensions"
			"categories": "listCategories"

	API =
		startAuthors: ->
			AuthorsApp.List.Controller.startAuthors()

		showAuthor: ->
			AuthorsApp.Show.Controller.showAuthor()

		listAuthors: ->
			AuthorsApp.List.Controller.listAuthors()

		listCategories: ->
			AuthorsApp.List.Controller.listCategories()

		listDimensions: ->
			AuthorsApp.List.Controller.listDimensions()


	App.addInitializer ->
		new AuthorsApp.Router
			controller: API
		API.startAuthors()
		# AuthorsApp.List.Controller.startAuthors()
