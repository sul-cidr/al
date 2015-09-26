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

    getAuthorsCategory: (cat) ->
      console.log 'cat = ',cat
      authors.fetch
        success: ->
          # exclude Evans, Fielding, Boswell
          filterCat = _.filter(authors.models,(item) ->
            item.get("author_id") < 10434 && #item.contains("categories", cat)
            item.get('categories').indexOf(cat) > -1;
            # _.contains(item.get("categories", cat))
            # item.where("'categories = any ("+cat+")'");
          )
          authors.reset(filterCat);
          console.log 'filtered authors; ',authors
          authors

    getAuthorEntities: (cb) ->
      authors.fetch
        success: ->
          # exclude Evans, Fielding, Boswell
          filterName = _.filter(authors.models,(item) ->
            item.get("author_id") < 10434;
          )
          authors.reset(filterName);
          cb authors

  App.reqres.setHandler "authors:category", (cat) ->
    API.getAuthorsCategory cat

  App.reqres.setHandler "author:entities", (cb) ->
    API.getAuthorEntities cb

  App.reqres.setHandler "author:entity", (id, cb) ->
    API.getAuthorEntity id, cb

  # CHECK ?? add initializer to populate authors once, then check before any other fetch
