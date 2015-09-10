@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Author extends Entities.Model

  class Entities.AuthorCollection extends Entities.Collection
    model: Entities.Author
    #url: Routes.users_path()
    url: '/authors.json'

  API =
    getAuthorEntities: (cb) ->
      # console.log Entities
      authors = new Entities.AuthorCollection()
      authors.fetch
        success: ->
          cb authors 

  App.reqres.setHandler "author:entities", (cb) ->
    API.getAuthorEntities cb

