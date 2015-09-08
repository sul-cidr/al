@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Authors extends Marionette.ItemView
		template: "authors/list/templates/list_authors"


	# AppLayoutView = Marionette.LayoutView.extend(
	#   template: 'authors/show/templates/show_authors'
	#   regions:
	#     title: '#authors-top'
	#     main: '#authors-content')
	# layoutView = new AppLayoutView
	# layoutView.render()