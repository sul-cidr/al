@AL.module "PlacesApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Layout extends App.Views.Layout
		template: "places/list/templates/list_layout"

		regions:
			headerRegion: "#header-region"
			placesRegion: "#places-region"

	class List.Header extends App.Views.ItemView
		template: "places/list/templates/_header"

	class List.Area extends App.Views.ItemView
		template: "places/list/templates/_area"
		tagName: "span"

	class List.Areas extends App.Views.CompositeView
		template: "places/list/templates/_areas"
		childView: List.Area
		emptyView: List.Empty 
		childViewContainer: "arealist"
		events: {'click a': 'drillAreas'}
		drillAreas: (event) ->
			console.log 'clicked a borough, ' + event.currentTarget		

	class List.Place extends App.Views.ItemView
		template: "places/list/templates/_place"
		tagName: "span"

	class List.Places extends App.Views.CompositeView
		template: "places/list/templates/_places"
		childView: List.Place
		emptyView: List.Empty 
		childViewContainer: "arealist"

	class List.Empty extends App.Views.ItemView
		template: "places/list/templates/_empty"
		tagName: "p"



