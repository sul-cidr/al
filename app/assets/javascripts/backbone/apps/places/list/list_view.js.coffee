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
    events: {
      "click a": "drillArea"
      "mouseenter a": "highlightArea"
      "mouseleave a": "unhighlightArea"
    }

    onAreaEnter: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      console.log 'enter area model #', id
      App.vent.trigger('area:highlight', id);

    onAreaLeave: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      console.log 'left area a'
      App.vent.trigger('area:unhighlight', id);

    getAreaIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

    drillArea: (event) ->
      @activeArea = this.model
      area = this.model
      console.log 'clicked area model ' + area.get("id")
      Backbone.history.navigate("areas/"+area.get("id"), true)

  class List.Areas extends App.Views.CompositeView
    template: "places/list/templates/_areas"
    childView: List.Area
    emptyView: List.Empty
    childViewContainer: "arealist"

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
