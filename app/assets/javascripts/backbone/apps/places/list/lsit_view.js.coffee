@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Places extends Marionette.ItemView
		template: "places/show/templates/show_places"

