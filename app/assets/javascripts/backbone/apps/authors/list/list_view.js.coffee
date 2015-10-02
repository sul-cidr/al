@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "authors/list/templates/list_layout"

    regions:
      headerRegion: "#title-region"
      dimensionsRegion: "#dimensions-region"
      categoriesRegion: "#categories-region"
      authorlistRegion: "#authorlist-region"

  class List.Title extends App.Views.ItemView
    template: "authors/list/templates/_title"
    events:
      "click .toggle-authors": "onToggle"
    # TODO: this is replicated in List.AuthorLayout and in Places
    onToggle: ->
      console.log 'toggle from List.Title'
      if $("#authors-region").offset().left == 0
        $("#authors-region").animate { 'left': -($("#authors-region").width() - 15) }, 500
      else if $("#authors-region").offset().left < 0
        $("#authors-region").animate { 'left': 0 }, 500

  class List.Dimensions extends App.Views.ItemView
    template: "authors/list/templates/_dimensions"
    # TODO on-click filter categories
    events: {
      "click li": "filterCats"
    }
    filterCats: (e) =>
      $("li").removeClass("active")
      $(e.currentTarget).addClass("active")
      dim = $(e.currentTarget).context.attributes.value.value
      # console.log 'List.Dimensions.filterCats by dimension: ' + dim
      List.Controller.listCategories(dim)

  class List.Author extends App.Views.ItemView
    template: "authors/list/templates/_author"
    tagName: "span"
    events: {'click a': 'authByRoute'}
    authByRoute: ->
      $activeAuthor = this.model
      # console.log $activeAuthor
      author = this.model
      Backbone.history.navigate("authors/"+author.get('author_id'), true)

  class List.Authors extends App.Views.CompositeView
    template: "authors/list/templates/_authors"
    childView: List.Author
    emptyView: List.Empty
    childViewContainer: "div"

  class List.Category extends App.Views.ItemView
    template: "authors/list/templates/_category"
    tagName: "span"
    # events: {"click": "filterAuthors"}
    events: {"click": "filterAuthors"}

    filterAuthors: (e) ->
      cat = this.model
      id = cat.attributes.id
      App.reqres.setHandler "category:active", ->
        return cat
      # CHECK does this need to be in navigate?
      App.request "authors:category", id, (authors) =>
        List.Controller.listCatAuthors(authors, id)
      App.vent.trigger "category:authors:show", cat

  class List.Categories extends App.Views.CompositeView
    template: "authors/list/templates/_categories"
    className: 'categories'
    childView: List.Category
    childViewContainer: "catlist"
    filter: (child, index, collection) ->
      # filter genre for initial display
      child.get('dim') == 'genre'
    onChildviewAuthorsFiltered: ->
      console.log 'bubbled up to List.Categories view'

  class List.Empty extends App.Views.ItemView
    template: "authors/list/templates/_empty"
    tagName: "p"
