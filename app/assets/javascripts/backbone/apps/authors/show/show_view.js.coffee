@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.AuthorLayout extends Marionette.ItemView
    # CHECK: why can't I put this in the Show module?
    template: "authors/show/templates/show_author"
    events:
      "click .toggle-authors": "onToggle"

    onToggle: ->
      console.log 'toggle from Show.AuthorLayout'
      if $("#authors-region").offset().left == 0
        $("#authors-region").animate { 'left': -($("#authors-region").width() - 15) }, 500
      else if $("#authors-region").offset().left < 0
        $("#authors-region").animate { 'left': 0 }, 500

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
