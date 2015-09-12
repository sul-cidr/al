@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Layout extends App.Views.Layout
		template: "authors/list/templates/list_layout"

		regions:
			authorsRegion: "#authors-region"
			headerRegion: "#title-region"
			dimensionsRegion: "#dimensions-region"
			categoriesRegion: "#catogories-region"
			authorlistRegion: "#authorlist-region"

	class List.Header extends App.Views.ItemView
		template: "authors/list/templates/_header"

	class List.Author extends App.Views.ItemView
		template: "authors/list/templates/_author"
		tagName: "span"

	class List.Authors extends App.Views.CompositeView
		template: "authors/list/templates/_authors"
		childView: List.Author
		emptyView: List.Empty 
		childViewContainer: "authlist"

	class List.Empty extends App.Views.ItemView
		template: "authors/list/templates/_empty"
		tagName: "p"
