@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Author extends Entities.Model

  class Entities.AuthorCollection extends Entities.Collection
    model: Entities.Author
    # url: '/authors.json'
    url: '/authors'
    # CHECK is idAttribu any use?
    idAttribute: "author_id"

  API =
    getAuthorEntities: (cb) ->
      # console.log Entities
      authors = new Entities.AuthorCollection()
      authors.fetch
        success: ->
          # never list Evans, Fielding, Boswell
          filterName = _.filter(authors.models,(item) ->
            item.get("author_id") < 10434;
          )
          authors.reset(filterName);
          cb authors

  App.reqres.setHandler "author:entities", (cb) ->
    API.getAuthorEntities cb
