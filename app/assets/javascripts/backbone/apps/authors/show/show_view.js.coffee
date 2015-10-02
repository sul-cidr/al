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
      "click .toggle-authors": "onToggle"
    # TODO: this is replicated in List.AuthorLayout and in Places
    onToggle: ->
      console.log 'toggle from Show.Title'
      if $("#authors-region").offset().left == 0
        $("#authors-region").animate { 'left': -($("#authors-region").width() - 15) }, 500
      else if $("#authors-region").offset().left < 0
        $("#authors-region").animate { 'left': 0 }, 500

  class Show.Pills extends App.Views.ItemView
    template: "authors/show/templates/_nav"
    events: {
      "click li": "loadContent"
    }
    loadContent: (e) =>
      $("li").removeClass("active")
      $(e.currentTarget).addClass("active")
      pill = $(e.currentTarget).context.attributes.value.value
      console.log 'Show.Pills.loadContent for: ' + pill
      # Show.Controller.listCategories(pill)

  class Show.Passage extends App.Views.ItemView
    template: "authors/show/templates/_passage"
    tagName: "p"
    events: {"click": "highlightPlacerefs"}
    highlightPlacerefs: ->
      console.log 'Show.Passage.highlightPlacerefs()'

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
      $("#li_pass").removeClass("hidden")
      # use route for model attributes and navigation
      Backbone.history.navigate("passages/"+work.get('work_id'), true)

  class Show.Works extends App.Views.CompositeView
    template: "authors/show/templates/_works"
    className: 'works'
    childView: Show.Work
    childViewContainer: "ul"
