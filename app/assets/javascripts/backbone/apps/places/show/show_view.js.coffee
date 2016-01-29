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
      "click .crumb-places": "goHome"

    goHome: ->
      console.log 'goHome() navigates to /places'
      App.vent.trigger("map:reset", "places_show")
      AL.PlacesApp.List.Controller.startPlaces()
      # Backbone.history.navigate("places", true)

  class Show.PlacePassage extends App.Views.ItemView
    template: "places/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.placeref": "onPlacerefClick"
      "mouseenter span.placeref": "onPlacerefEnter"
      "mouseleave span.placeref": "onPlacerefLeave"
    }

    onPlacerefClick: (e) ->
      # window.context = $(e.currentTarget).context
      prid = this.getPlacerefIdFromEvent(e);
      # prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'clicked placeref', prid
      App.vent.trigger('placeref:click', prid)

    onPlacerefEnter: (e) ->
      prid = this.getPlacerefIdFromEvent(e);
      # console.log 'highlight placeref #', prid
      # App.vent.trigger('placeref:highlight', prid);
      # App.vent.trigger('placeref:hover', e)

    onPlacerefLeave: (e) ->
      prid = this.getPlacerefIdFromEvent(e);
      # console.log 'left placeref span'
      # App.vent.trigger('placeref:unhighlight', prid);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.val.value);

  class Show.PlacePassages extends App.Views.CompositeView
    template: "places/show/templates/_passages"
    childView: Show.PlacePassage
    childViewContainer: "placepassages"
    events: {
      "click #passage_closer": "closeRightPanel"
    }

    closeRightPanel: ->
      App.placePassagesRegion.$el.addClass('hidden')
      map.closePopup()

  class Show.Content extends App.Views.ItemView
    template: "places/show/templates/_content"
