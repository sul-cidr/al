@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Map extends Marionette.ItemView
		template: "map/show/templates/show_map"


    tester: ->
      console.log this.ui.map


    # map = L.mapbox.map('map', 'mapbox.streets')
    #   .setView([51.5072, 0.1275], 9)

