@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "places/show/templates/show_layout"
    regions:
      titleRegion: "#place_title_region"
      navRegion: "#place_nav_region"
      placeContentRegion: "#place_content_region"

  class Show.Title extends App.Views.ItemView
    template: "places/show/templates/_title"
    events:
      "click .toggle-places": "onToggle"
      "click .crumb-places": "goHome"

    onToggle:
      AL.PlacesApp.List.Controller.togglePanel

    goHome: (e) ->
      # TODO: clear unhighlight area, zoom out
      # console.log 'goHome()', $(e.currentTarget)
      id = Number($(e.currentTarget).context.attributes.data_id.value)
      App.vent.trigger("area:unhighlight", id)
      Backbone.history.navigate("", true)

  class Show.Hood extends App.Views.ItemView
    template: "places/show/templates/_hood"
    tagName: "span"
    events: {
      "click a": "hoodByRoute"
      # "mouseenter a": "onAreaEnter"
      # "mouseleave a": "onAreaLeave"
    }

    hoodByRoute: ->
      window.activeHood = this.model
      hood = this.model
      Backbone.history.navigate("hoods/"+hood.get("id"), true)

    # needed for map interaction
    # onAreaEnter: (e) ->
    #   id = this.getAreaIdFromEvent(e);
    #   # console.log 'enter area model #', id
    #   App.vent.trigger('area:highlight', id);
    #
    # onAreaLeave: (e) ->
    #   id = this.getAreaIdFromEvent(e);
    #   # console.log 'left area a'
    #   App.vent.trigger('area:unhighlight', id);
    #
    # getAreaIdFromEvent: (e) ->
    #   Number($(e.currentTarget).context.attributes.data_id.value);


  class Show.Hoods extends App.Views.CompositeView
    template: "places/show/templates/_hoods"
    childView: Show.Hood
    emptyView: Show.Empty
    childViewContainer: "hoodslist"

  class Show.Content extends App.Views.ItemView
    template: "places/show/templates/_content"
