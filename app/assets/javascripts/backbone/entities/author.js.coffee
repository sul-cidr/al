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
    
    getAuthorEntity: (id, cb) ->
      @author = authors._byId[id]
      cb @author

    getAuthorsCategory: (cat, cb) ->
      # console.log 'in entity, cat =',cat
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
          # TODO this executes twice??
          # console.log authors.models.length + ' filtered authors'
          cb authors

    getAuthorEntities: (cb) ->
      authors.fetch
        success: ->
          # exclude Evans, Fielding, Boswell
          filterName = _.filter(authors.models,(item) ->
            item.get("author_id") < 10434;
          )
          authors.reset(filterName);
          cb authors


  App.reqres.setHandler "authors:active", (cb) ->
    cb activeAuthors

  App.reqres.setHandler "authors:category", (cat, cb) ->
    API.getAuthorsCategory cat, cb

  App.reqres.setHandler "author:entities", (cb) ->
    API.getAuthorEntities cb

  App.reqres.setHandler "author:entity", (id, cb) ->
    API.getAuthorEntity id, cb


  # CHECK ?? add initializer to populate authors once, then check before any other fetch
