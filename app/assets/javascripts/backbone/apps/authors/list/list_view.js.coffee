@AL.module "AuthorsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "authors/list/templates/list_layout"

    regions:
      # headerRegion: "#title_region"
      # dimensionsRegion: "#dimensions_region"
      categoriesRegion: "#categories_region"
      authorlistRegion: "#authorlist_region"

    events: {
      "click .clear": "removeFilter"
    }

    removeFilter: ->
      # console.log 'remove filter'
      $("#selected_cat_authors").html('')
      App.request "authors:category", 0, (authors) =>
        List.Controller.listCatAuthors(authors)
        App.vent.trigger("map:reset")

  class List.Title extends App.Views.ItemView
    template: "authors/list/templates/_title"
    events:
      "click .toggle-authors": "onToggle"
    onToggle:
      AL.AuthorsApp.List.Controller.togglePanel

  class List.Author extends App.Views.ItemView
    template: "authors/list/templates/_author"
    tagName: "span"
    events: {'click a': 'authByRoute'}
    authByRoute: ->
      # $("#spin_authors").removeClass('hidden')
      $activeAuthor = this.model
      author = this.model
      @route = "authors/" + author.get('author_id')
      # runs AuthorsApp.Show.Controller.showAuthor()
      Backbone.history.navigate(@route, true)

  class List.Authors extends App.Views.CompositeView
    template: "authors/list/templates/_authors"
    childView: List.Author
    emptyView: List.Empty
    childViewContainer: "div"


  class List.Empty extends App.Views.ItemView
    template: "authors/list/templates/_empty"
    tagName: "p"
