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
      "click .crumb-authors": "goHome"

    goHome: ->
      # restore dimensions dropdowns
      $("#dimensions_region").show()
      # execute startAuthors()
      Backbone.history.navigate("authors", true)
      App.vent.trigger("map:reset")

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
        @route = "works/"+authid
        console.log 'loadContent, works:', @route
        # CHECK: is this Navigate...true right?
        Backbone.history.navigate(@route, true)
        # Show.Controller.listWorks authid
      else if @pill == 'biography'
        @route = "authors/"+authid
        console.log 'loadContent, bio:', @route
        Backbone.history.navigate(@route, true)
        # Show.Controller.showAuthor authid

  class Show.Passage extends App.Views.ItemView
    template: "authors/show/templates/_passage"
    tagName: "p"
    events: {
      # "click": "highlightPlacerefs"
      "mouseenter span.place": "onPlacerefEnter"
      "mouseleave span.place": "onPlacerefLeave"
    }
    # highlightPlacerefs: ->
    #   console.log 'Show.Passage.highlightPlacerefs()'

    onPlacerefEnter: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      console.log 'highlight placeref #', id
      App.vent.trigger('placeref:highlight', id);
      # App.vent.trigger('placeref:hover', e)

    onPlacerefLeave: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      # console.log 'left placeref span'
      App.vent.trigger('placeref:unhighlight', id);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

  # passages are shown by clicking a work
  class Show.Passages extends App.Views.CompositeView
    template: "authors/show/templates/_passages"
    childView: Show.Passage
    childViewContainer: "div"

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
    childView: Show.Work
    childViewContainer: "div"
