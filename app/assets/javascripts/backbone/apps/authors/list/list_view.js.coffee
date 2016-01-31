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
      'click input': 'checkedAuthors'
    }

    initialize: ->
      @checked = []
      # console.log '@checked', @checked

    # targeting renderPlaces(params, key, clear=true)
    # or removePlaces(key)
    checkedAuthors: (e) ->
      # console.clear()
      console.log $("#legend_list li")
      selected = parseInt($(e.currentTarget).context.value)
      key = 'auth_'+selected
      if @checked.indexOf(selected) < 0 # not selected
        @checked.push(selected)
        checkedCount = @checked.length
        window.checked = @checked
        console.log 'added', selected + ', checked now', @checked
        if $( ".author input:checked" ).length == 3
          $( ".author input:not(:checked)" ).attr('disabled', 'disabled');
        else
          $('.author input').removeAttr('disabled');
        # for map
        App.vent.trigger "author:checked",
          author_id: selected,
          key: key,
          clear: if checkedCount==1 then true else false
      else # author now unchecked, remove it
        idx = @checked.indexOf(selected)
        @checked.splice(idx, 1)
        checkedCount = @checked.length
        console.log selected + ' removed, @checked now', @checked, checkedCount
        if $( ".author input:checked" ).length == 3
          $( ".author input:not(:checked)" ).attr('disabled', 'disabled');
        else
          $('.author input').removeAttr('disabled');
        # for map
        App.vent.trigger "author:unchecked",
          author_id: selected,
          key: key
          count: checkedCount



    removeFilter: ->
      console.log 'remove filter'
      $("#selected_cat_authors").html('')
      # get all authors
      App.request "authors:category", {clear:true}, (authors) =>
        List.Controller.listCatAuthors(authors)
        App.vent.trigger("map:reset", 'authors_list')

  class List.Title extends App.Views.ItemView
    template: "authors/list/templates/_title"
    events:
      "click .toggle-authors": "onToggle"
    onToggle:
      AL.AuthorsApp.List.Controller.togglePanel

  class List.Author extends App.Views.ItemView
    template: "authors/list/templates/_author"
    tagName: "span"
    events: {
      'click a': 'authByRoute'
      # 'click input': 'aggAuthors'
    }

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
