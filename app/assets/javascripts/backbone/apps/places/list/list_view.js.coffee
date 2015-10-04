@AL.module "PlacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "places/list/templates/list_layout"

    regions:
      titleRegion: "#title-region"
      navmapRegion: "#navmap-region"
      arealistRegion: "#arealist-region"

  class List.Title extends App.Views.ItemView
    template: "places/list/templates/_title"
    events:
      "click .toggle-places": "onToggle"
    onToggle: ->
      xpos = ($(window).width() - 350) - $("#places-region").offset().left
      if xpos == 0
        $("#places-region").animate { 'right': -($("#places-region").width() - 15) }, 500
      else if $("#places-region").offset().left > $(window).width() - 350
        $("#places-region").animate { 'right': 0}, 500

  class List.Navmap extends App.Views.ItemView
    template: "places/list/templates/_navmap"

  class List.Area extends App.Views.ItemView
    template: "places/list/templates/_area"
    tagName: "span"

  class List.Areas extends App.Views.CompositeView
    template: "places/list/templates/_areas"
    childView: List.Area
    emptyView: List.Empty
    childViewContainer: "arealist"
    events: {'click a': 'drillAreas'}
    drillAreas: (event) ->
      console.log 'clicked a borough, ' + event.currentTarget

  # places not used yet
  # class List.Place extends App.Views.ItemView
  #   template: "places/list/templates/_place"
  #   tagName: "span"
  #
  # class List.Places extends App.Views.CompositeView
  #   template: "places/list/templates/_places"
  #   childView: List.Place
  #   emptyView: List.Empty
  #   childViewContainer: "arealist"

  class List.Empty extends App.Views.ItemView
    template: "places/list/templates/_empty"
    tagName: "p"
