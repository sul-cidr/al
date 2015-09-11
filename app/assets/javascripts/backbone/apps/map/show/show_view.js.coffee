@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Map extends Marionette.ItemView
		template: "map/show/templates/show_map"
    # render: ->
    #   @$el.html(this.template());

    #   map = L.mapbox.map('map', 'mapbox.streets')
    #     .setView([40, -74.50], 9)
