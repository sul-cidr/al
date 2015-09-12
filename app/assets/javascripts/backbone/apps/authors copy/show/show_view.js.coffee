@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Author extends Marionette.ItemView
		template: "authors/show/templates/show_author"

	# AppLayoutView = Marionette.LayoutView.extend(
	#   template: 'authors/show/templates/show_authors'
	#   regions:
	#     title: '#authors-top'
	#     main: '#authors-content')
	# layoutView = new AppLayoutView
	# layoutView.render()