@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Layout extends App.Views.Layout
		template: "authors/list/templates/list_layout"

		regions:
			headerRegion: "#title-region"
			dimensionsRegion: "#dimensions-region"
			categoriesRegion: "#categories-region"
			authorlistRegion: "#authorlist-region"

	class List.Header extends App.Views.ItemView
		template: "authors/list/templates/_header"

	class List.Dimensions extends App.Views.ItemView
		template: "authors/list/templates/_dimensions"
		# TODO on-click filter categories
		events: {'click a': 'filterCats'}
		filterCats: (event) ->
			console.log 'clicked a dimension, ' + event.currentTarget

	class List.Category extends App.Views.ItemView
		template: "authors/list/templates/_category"
		tagName: "span"

	class List.Categories extends App.Views.CompositeView
		template: "authors/list/templates/_categories"
		className: 'categories'
		childView: List.Category
		childViewContainer: "catlist"
		filter: (child, index, collection) ->
			child.get('dim') == 'genre'

	class List.Author extends App.Views.ItemView
		template: "authors/list/templates/_author"
		tagName: "span"

	class List.Authors extends App.Views.CompositeView
		template: "authors/list/templates/_authors"
		childView: List.Author
		emptyView: List.Empty 
		# el: $("#authorlist-region")
		childViewContainer: "div"
		# an attempt to sort
	  # onRender: ->
	  #   collection = @collection
	  #   collection.comparator = (collection) ->
	  #     -collection.get('surname')
	  #   return
	  # onSuccess: ->
	  # 	@collection.sort()

	class List.Empty extends App.Views.ItemView
		template: "authors/list/templates/_empty"
		tagName: "p"
