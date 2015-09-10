@AL.module "PlacesApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Layout extends App.Views.Layout
		template: "places/list/templates/list_layout"

		regions:
			headerRegion: "#header-region"
			placesRegion: "#places-region"

	class List.Header extends App.Views.ItemView
		template: "places/list/templates/_header"

	class List.Place extends App.Views.ItemView
		template: "places/list/templates/_place"
		tagName: "span"

	class List.Authors extends App.Views.CompositeView
		template: "places/list/templates/_places"
		childView: List.Place
		emptyView: List.Empty 
		childViewContainer: "placelist"

	class List.Empty extends App.Views.ItemView
		template: "places/list/templates/_empty"
		tagName: "p"



