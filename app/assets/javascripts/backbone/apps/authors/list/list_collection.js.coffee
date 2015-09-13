@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

	class List.Collection extends Backbone.Collection
    url: '/authors.json'

  class List.CatCollection extends Backbone.Collection
    url: '/categories.json'