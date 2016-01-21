@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "authors/show/templates/show_layout"
    # template: "authors/show/templates/show_author"
    regions:
      titleRegion: "#title_region"
      navRegion: "#nav_region"
      authorContentRegion: "#author_content_region"

  class Show.Title extends App.Views.ItemView
    template: "authors/show/templates/_title"
    events:
      "click #crumb_authors": "goHome"
      "click #crumb_author": "goAuthor"

    goHome: ->
      # restore dimensions dropdowns
      $("#dimensions_region").removeClass("hidden")
      # execute startAuthors()
      # Backbone.history.history.back()
      Backbone.history.navigate("authors", true)
      App.vent.trigger("map:reset")
    goAuthor: (e) ->
      # window.location.hash
      # console.log $(e.currentTarget).context.attributes
      id = $(e.currentTarget).context.attributes.val.value
      Backbone.history.navigate("authors/"+id, true)

  class Show.Pills extends App.Views.ItemView
    template: "authors/show/templates/_nav"
    events: {
      "click li": "loadContent"
    }
    loadContent: (e) =>
      $(".nav-pills li").removeClass("active")
      $(e.currentTarget).addClass("active")
      authid = App.request("author:model").get("author_id")
      @pill = $(e.currentTarget).context.attributes.value.value
      if @pill == 'works'
        $("#passages_pill").addClass("hidden")
        if $("#crumb_works").length < 1
          $("#author_crumbs").append('<span id="crumb_works" class="crumb-left"> :: Works </span>')
        $("#crumb_author").addClass("crumb-link")
        @route = "works/"+authid
        # console.log 'loadContent, works:', @route
        Backbone.history.navigate(@route, true)
        # Show.Controller.listWorks authid
      else if @pill == 'biography'
        @route = "authors/"+authid
        # executes Show.Controller.showAuthor
        Backbone.history.navigate(@route, true)

  class Show.Passage extends App.Views.ItemView
    template: "authors/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.placeref": "onPlacerefClick"
      "mouseenter span.placeref": "onPlacerefEnter"
      # TODO: is this right behavior?
      # "mouseleave span.placeref": "onPlacerefLeave"
    }

    onPlacerefClick: (e) ->
      # window.context = $(e.currentTarget).context
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefClick', prid
      App.vent.trigger('placeref:click', prid)

    onPlacerefEnter: (e) ->
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefEnter', prid
      # App.vent.trigger('placeref:highlight', prid);

    onPlacerefLeave: (e) ->
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefLeave', id
      # App.vent.trigger('placeref:unhighlight', prid);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

  # passages are shown by clicking a work
  class Show.Passages extends App.Views.CompositeView
    template: "authors/show/templates/_passages"
    childView: Show.Passage
    childViewContainer: "div"
    # className: 'passages-works'

  class Show.Work extends App.Views.ItemView
    template: "authors/show/templates/_work"
    tagName: "span"
    events: {"click": "loadPassages"}
    loadPassages: ->
      work = this.model
      # show tab CHECK: leave visible?
      $("#passages_pill").removeClass("hidden")
      $(".nav-pills li").removeClass("active")
      $("#passages_pill").addClass("active")
      # use route for model attributes and navigation
      Backbone.history.navigate("workpassages/a/"+work.get('work_id'), true)

  class Show.Works extends App.Views.CompositeView
    template: "authors/show/templates/_works"
    className: 'works'
    # childView: Show.D3Thing
    childView: Show.Work
    childViewContainer: "div"
