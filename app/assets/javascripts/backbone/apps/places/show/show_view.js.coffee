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
      "click .crumb0 a": "goHome"

    goHome: (e) ->
      # TODO:
      # console.log 'goHome()', $(e.currentTarget)
      # clear the vis
      $("#place_content_region").hide()
      # get id to unhighlight
      id = Number($(e.currentTarget).context.attributes.data_id.value)
      # console.log 'goHome() id=', id
      App.vent.trigger("map:reset", id)
      App.vent.trigger("area:unhighlightAll", id)
      # App.vent.trigger("area:unhighlight", id)
      Backbone.history.navigate("places", true)

  class Show.PlacePassage extends App.Views.ItemView
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
