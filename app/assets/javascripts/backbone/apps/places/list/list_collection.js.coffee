@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->

	class List.Collection extends Backbone.Collection
		
    url: '/places.json'