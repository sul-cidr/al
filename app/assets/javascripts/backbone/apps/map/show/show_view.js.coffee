@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Header extends Marionette.ItemView
		template: "map/show/templates/show_map"

