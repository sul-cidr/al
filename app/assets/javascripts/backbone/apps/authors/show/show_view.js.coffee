@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Authors extends Marionette.ItemView
		template: "authors/show/templates/show_authors"

