@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.AuthorView extends Marionette.ItemView
		template: "authors/list/templates/list_author"

	class List.AuthorsView extends Marionette.CollectionView
		template: "authors/list/templates/list_authors"

		getChildView: ->
			List.AuthorView

