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
    events:
      "click .toggle-authors": "onToggle"
    onToggle: ->
      console.log 'onToggle()'
      if $("#authors-region").offset().left == 0
        console.log '.closer click to left'
        $("#authors-region").animate { 'left': -($("#authors-region").width() - 12) }, 500
        # $(".closer").attr("class","closer fa fa-caret-square-o-right");
      else if $("#authors-region").offset().left < 0
        console.log '.closer click to right'
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

  class List.Work extends App.Views.ItemView
    template: "authors/list/templates/_work"
    tagName: "li"
    events: {"click": "loadPassages"}
    loadPassages: ->
      work = this.model
      # show tab CHECK: leave visible?
      $("#li_pass").removeClass("hidden")
      # use route for model attributes and navigation
      Backbone.history.navigate("passages/"+work.get('work_id'), true)

  class List.Works extends App.Views.CompositeView
    template: "authors/list/templates/_works"
    className: 'works'
    childView: List.Work
    childViewContainer: "ul"

  class List.Passage extends App.Views.ItemView
    template: "authors/list/templates/_passage"
    tagName: "p"
    events: {"click": "highlightPlacerefs"}
    highlightPlacerefs: ->
      console.log 'List.Passage.highlightPlacerefs()'

  class List.Passages extends App.Views.CompositeView
    template: "authors/list/templates/_passages"
    className: 'passages'
    childView: List.Passage
    childViewContainer: "div"

  class List.AuthorLayout extends Marionette.ItemView
    template: "authors/show/templates/show_author"

  class List.Author extends App.Views.ItemView
    template: "authors/list/templates/_author"
    tagName: "span"
    events: {'click a': 'authByRoute'}
    authByRoute: ->
      #/ route runs API.showAuthor --> gets model 'author' -->
      #/ AuthorsApp.List.Controller.showAuthor(author)
      author = this.model
      console.log 'clicked this author:', author
      # @activeAuthor = author
      Backbone.history.navigate("authors/"+author.get('author_id'), true)

  class List.Authors extends App.Views.CompositeView
    template: "authors/list/templates/_authors"
    childView: List.Author
    emptyView: List.Empty
    childViewContainer: "div"

  class List.Category extends App.Views.ItemView
    template: "authors/list/templates/_category"
    tagName: "span"
    events: {"click": "filterAuths"}
    filterAuths: ->
      cat = this.model
      id = cat.attributes.id
      console.log 'clicked '+ id + ', filter auth list & map'
      App.request "authors:category", id, (authors) =>
        List.Controller.listCatAuthors(authors, id)
        # MapApp.Show.Controller.showMap(authors)


  class List.Categories extends App.Views.CompositeView
    template: "authors/list/templates/_categories"
    className: 'categories'
    childView: List.Category
    childViewContainer: "catlist"
    filter: (child, index, collection) ->
      # filter genre for initial display
      child.get('dim') == 'genre'

  class List.Empty extends App.Views.ItemView
    template: "authors/list/templates/_empty"
    tagName: "p"
