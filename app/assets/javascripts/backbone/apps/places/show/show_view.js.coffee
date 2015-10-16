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
      "click .crumb0 a": "goHome"
      "click .crumb1 a": "goBorough"

    onToggle:
      AL.PlacesApp.List.Controller.togglePanel

    goBorough: (e) ->
      # step back up

      # id = App.request("borough:active:model").get("id")
      id = Number($(e.currentTarget).context.attributes.data_id.value)
      # console.log 'navigate to', "boroughs/"+id
      console.log 'fragment', Backbone.history.fragment
      # Backbone.history.navigate("boroughs/"+id, true)
      App.vent.trigger "area:focus", App.request("area:entity", id)

    goHome: (e) ->
      # TODO: clear unhighlight area, zoom out
      # console.log 'goHome()', $(e.currentTarget)
      id = Number($(e.currentTarget).context.attributes.data_id.value)
      # console.log 'goHome() id=', id
      App.vent.trigger("map:reset", id)
      App.vent.trigger("area:unhighlightAll", id)
      # App.vent.trigger("area:unhighlight", id)
      Backbone.history.navigate("places", true)

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
      @activeHood = this.model
      # console.log @activeHood
      id = @activeHood.get("id")
      Backbone.history.navigate("hoods/"+id, true)
      $("#crumbs_places ul").append(
        '>> <li class="crumb1"><a href="#" data_id="'+@activeHood.get("parent_id")+'">parent</a></li>'
      );


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

  class Show.Passages extends App.Views.CompositeView
    template: "places/show/templates/_passages"
    childView: Show.Passage
    childViewContainer: "div"


  class Show.Passage extends App.Views.ItemView
    template: "places/show/templates/_passage"
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

  class Show.Content extends App.Views.ItemView
    template: "places/show/templates/_content"
