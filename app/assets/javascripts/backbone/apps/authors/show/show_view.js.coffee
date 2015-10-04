@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  channels: ['passage', 'passages', 'placerefs', 'map']

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
      "click .toggle-authors": "onToggle"
      "click .crumb": "goHome"
    # TODO: this is replicated in List.AuthorLayout and in Places
    onToggle: ->
      console.log 'toggle from Show.Title'
      if $("#authors-region").offset().left == 0
        $("#authors-region").animate { 'left': -($("#authors-region").width() - 15) }, 500
      else if $("#authors-region").offset().left < 0
        $("#authors-region").animate { 'left': 0 }, 500
    goHome: ->
      Backbone.history.navigate("", true)

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
        @route = "#works/"+authid
        # console.log 'loadContent, works:', @route
        Backbone.history.navigate(@route, true)
        # Show.Controller.listWorks authid
      else if @pill == 'biography'
        @route = "#authors/"+authid
        # console.log 'loadContent, bio:', @route
        Backbone.history.navigate(@route, true)
        # Show.Controller.showAuthor authid
      # passages are shown by clicking a work

  class Show.Passage extends App.Views.ItemView
    template: "authors/show/templates/_passage"
    tagName: "p"
    events: {
      "click": "highlightPlacerefs"
      "mouseenter span.placeref": "onPlacerefEnter"
      "mouseleave span.placeref": "onPlacerefLeave"
    }
    highlightPlacerefs: ->
      console.log 'Show.Passage.highlightPlacerefs()'

    onPlacerefEnter: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      this.channels.placerefs.trigger('highlight', id);
      this.channels.passage.trigger('hover', e)

    onPlacerefLeave: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      this.channels.placerefs.trigger('unhighlight', id);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).attr('data-id'));

  class Show.Passages extends App.Views.CompositeView
    template: "authors/show/templates/_passages"
    className: 'passages'
    childView: Show.Passage
    childViewContainer: "div"

  class Show.Work extends App.Views.ItemView
    template: "authors/show/templates/_work"
    tagName: "li"
    events: {"click": "loadPassages"}
    loadPassages: ->
      work = this.model
      # show tab CHECK: leave visible?
      $("#passages_pill").removeClass("hidden")
      $(".nav-pills li").removeClass("active")
      $("#passages_pill").addClass("active")
      # use route for model attributes and navigation
      Backbone.history.navigate("workpassages/"+work.get('work_id'), true)

  class Show.Works extends App.Views.CompositeView
    template: "authors/show/templates/_works"
    className: 'works'
    childView: Show.Work
    childViewContainer: "ul"
