@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "authors/list/templates/list_layout"

    regions:
      headerRegion: "#title_region"
      dimensionsRegion: "#dimensions_region"
      categoriesRegion: "#categories_region"
      authorlistRegion: "#authorlist_region"

  class List.Title extends App.Views.ItemView
    template: "authors/list/templates/_title"
    events:
      "click .toggle-authors": "onToggle"
    onToggle:
      AL.AuthorsApp.List.Controller.togglePanel

  class List.Dimensions extends App.Views.ItemView
    template: "authors/list/templates/_dimensions"
    # TODO on-click filter categories
    events: {
      "click #dimension_pills li": "filterCats"
    }
    filterCats: (e) =>
      $("#dimension_pills li").removeClass("active")
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
      author = this.model
      route = "authors/" + author.get('author_id')
      # runs showAuthor()
      console.log 'route', route
      Backbone.history.navigate(route, true)

  class List.Authors extends App.Views.CompositeView
    template: "authors/list/templates/_authors"
    childView: List.Author
    emptyView: List.Empty
    childViewContainer: "div"

  class List.Category extends App.Views.ItemView
    template: "authors/list/templates/_category"
    tagName: "span"
    # events: {"click": "filterAuthors"}
    events: {
      "click li.category": "filterAuthors"
    }

    filterAuthors: (e) ->
      # select a category, filter authors and map
      seltext =
        '<span class="strong">'+
        $(e.currentTarget).context.innerHTML +
        '</span><span class="right crumb"><a href="#">Clear filter</a></span>'
      $("#selected_cat_authors").html(seltext)

      cat = this.model
      window.activecat = cat
      id = cat.attributes.id
      console.log 'filter authors, cat: ' + id
      # get a collection of author models for category
      App.request "authors:category", id, (authors) =>
        List.Controller.listCatAuthors(authors, id)

      # trigger picked up by map_app
      App.vent.trigger "category:authors:show", cat
      App.reqres.setHandler "category:active", ->
        return cat

  class List.Categories extends App.Views.CompositeView
    template: "authors/list/templates/_categories"
    className: 'categories'
    childView: List.Category
    childViewContainer: ".catlist"
    events: {
      "click #selected_cat_authors a": "removeFilter"
    }
    filter: (child, index, collection) ->
      # filter genre for initial display
      child.get('dim') == 'genre'
    onChildviewAuthorsFiltered: ->
      # console.log 'bubbled up to List.Categories view'
    removeFilter: (e) ->
      # console.log 'remove filter'
      $("#selected_cat_authors").remove()
      App.request "authors:category", 0, (authors) =>
        List.Controller.listCatAuthors(authors, 0)
        App.vent.trigger("map:reset")

  class List.Empty extends App.Views.ItemView
    template: "authors/list/templates/_empty"
    tagName: "p"
