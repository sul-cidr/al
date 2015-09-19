@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "authors/list/templates/list_layout"

    regions:
      headerRegion: "#title-region"
      dimensionsRegion: "#dimensions-region"
      categoriesRegion: "#categories-region"
      authorlistRegion: "#authorlist-region"

  class List.Header extends App.Views.ItemView
    template: "authors/list/templates/_header"

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

  class List.Category extends App.Views.ItemView
    template: "authors/list/templates/_category"
    tagName: "span"
    events: {"click": "filterAuths"}
    filterAuths: ->
      cat = this.model
      id = cat.attributes.id
      App.request "author:entities", (authors) =>
        # console.log authors
        # console.log 'List.Category.filterAuths by category:',id
        List.Controller.listCatAuthors(authors, id)

  class List.Categories extends App.Views.CompositeView
    template: "authors/list/templates/_categories"
    className: 'categories'
    childView: List.Category
    childViewContainer: "catlist"
    filter: (child, index, collection) ->
      child.get('dim') == 'genre'
      # child.get('dim') == @dim

  class List.AuthorLayout extends Marionette.ItemView
    template: "authors/show/templates/show_author"

  class List.Author extends App.Views.ItemView
    template: "authors/list/templates/_author"
    tagName: "span"
    # events: {'click a': 'showAuth'}
    events: {'click': 'showAuth'}
    showAuth: ->
      # id = this.model.get('author_id')
      author = this.model
      console.log 'author '+author.attributes.author_id+' model clicked'
      List.Controller.showAuthor(author)

  class List.Authors extends App.Views.CompositeView
    template: "authors/list/templates/_authors"
    childView: List.Author
    emptyView: List.Empty
    childViewContainer: "div"


  class List.Empty extends App.Views.ItemView
    template: "authors/list/templates/_empty"
    tagName: "p"
