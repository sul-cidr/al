@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

	class List.Collection extends Backbone.Collection
		
    url: '/authors.json'