@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Map extends Marionette.ItemView
		template: "map/show/templates/show_map"

