@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Layout extends App.Views.Layout
		template: "authors/list/templates/list_layout"

		regions:
			headerRegion: "#header-region"
			authorsRegion: "#authors-region"

	class List.Header extends App.Views.ItemView
		template: "authors/list/templates/_header"

	class List.Author extends App.Views.ItemView
		template: "authors/list/templates/_author"
		tagName: "span"
		templateHelpers: 'view_helpers'

	class List.Authors extends App.Views.CompositeView
		template: "authors/list/templates/_authors"
		childView: List.Author
		emptyView: List.Empty 
		childViewContainer: "authlist"

	class List.Empty extends App.Views.ItemView
		template: "authors/list/templates/_empty"
		tagName: "p"

	# class List.AuthorView extends App.Views.ItemView
	# 	template: "authors/list/templates/list_author"

	# class List.AuthorsView extends App.Views.CollectionView
	# 	template: "authors/list/templates/list_authors"

	# 	getChildView: ->
	# 		List.AuthorView

