@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Genre extends Entities.Model

  class Entities.GenreCollection extends Entities.Collection
    model: Entities.Genre
    url: '/genres'

  API =
    getGenreEntities: (cb) ->
      # console.log Entities
      genres = new Entities.CategoryCollection()
      genres.fetch
        success: ->
          cb genres

  App.reqres.setHandler "genre:entities", (cb) ->
    API.getGenreEntities cb
