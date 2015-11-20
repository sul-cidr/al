@AL.module "Entities", (Entities, App, Backbone, Marionette, $,  _) ->

  class Entities.Author extends Entities.Model
    idAttribute: "author_id"
    url: '/authors/:author_id'

  class Entities.AuthorCollection extends Entities.Collection
    model: Entities.Author
    url: '/authors'
    comparator: 'surname'
    # CHECK is idAttribute any use?
    idAttribute: "author_id"

  authors = new Entities.AuthorCollection

  author = new Entities.Author

  API =

    getAuthorEntities: (cb) ->
      authors.fetch
        success: ->
          # exclude Evans, Fielding, Boswell
          filterName = _.filter(authors.models,(item) ->
            item.get("author_id") < 10434;
          )
          authors.reset(filterName);
          cb authors

    getAuthorEntity: (id, cb) ->
      @author = authors._byId[id]
      cb @author

    # TODO this executes twice, from authors_app and map_app
    getAuthorsCategory: (cat, cb) ->
      # console.log 'API.getAuthorsCategory', cat
      authors.fetch
        success: ->
          _.each authors.models, (a) =>
            # console.log a.attributes.categories
          filterCat = _.filter(authors.models,(item) ->
            item.get("author_id") < 10434 && #item.contains("categories", cat)
            item.get('categories').indexOf(cat) > -1;
          )
          authors.reset(filterCat);
          # console.log authors.models.length + ' authors from API'
          cb authors

  App.reqres.setHandler "author:entities", (cb) ->
    API.getAuthorEntities cb

  App.reqres.setHandler "author:entity", (id, cb) ->
    API.getAuthorEntity id, cb

  App.reqres.setHandler "authors:category", (cat, cb) ->
    API.getAuthorsCategory cat, cb

  # CHECK ?? add initializer to populate authors once, then check before any other fetch
