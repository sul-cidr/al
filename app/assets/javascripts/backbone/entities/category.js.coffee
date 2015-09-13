@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.CategoryCollection extends Entities.Collection
    model: Entities.Category
    #url: Routes.users_path()
    url: '/categories.json'

  API =
    getCategoryEntities: (cb) ->
      # console.log Entities
      categories = new Entities.CategoryCollection()
      categories.fetch
        success: ->
          cb categories 

  App.reqres.setHandler "category:entities", (cb) ->
    API.getcategoryEntities cb
