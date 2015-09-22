@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Author extends Entities.Model
    idAttribute: "author_id"
    url: '/authors/:author_id'

  class Entities.AuthorCollection extends Entities.Collection
    model: Entities.Author
    # url: '/authors.json'
    url: '/authors'
    # CHECK is idAttribute any use?
    idAttribute: "author_id"

  authors = new Entities.AuthorCollection

  API =
    getAuthorEntity: (id, cb) ->
      author = authors._byId[id]
      cb author

    getAuthorEntities: (cb) ->
      authors.fetch
        success: ->
          # exclude Evans, Fielding, Boswell
          filterName = _.filter(authors.models,(item) ->
            item.get("author_id") < 10434;
          )
          authors.reset(filterName);
          cb authors

  App.reqres.setHandler "author:entities", (cb) ->
    API.getAuthorEntities cb

  App.reqres.setHandler "author:entity", (id, cb) ->
    API.getAuthorEntity id, cb

  # CHECK ?? add initializer to populate authors once, then check before any other fetch
