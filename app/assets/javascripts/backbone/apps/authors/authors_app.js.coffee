@AL.module "AuthorsApp", (AuthorsApp, App, Backbone, Marionette, $, _) ->
	# @startWithParent = false

	class AuthorsApp.Router extends Marionette.AppRouter
		appRoutes:
			"authors": "listAuthors"
			"author/:id": "showAuthor" # pass author_id
			"dimensions": "listDimensions"
			"categories": "listCategories"

	API =
		startAuthors: ->
			# console.log 'API.startAuthors()'
			AuthorsApp.List.Controller.startAuthors()

		# single author
		showAuthor: (id) ->
			AuthorsApp.Show.Controller.showAuthor(id)

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
		# AuthorsApp.Show.Controller.showAuthor()
