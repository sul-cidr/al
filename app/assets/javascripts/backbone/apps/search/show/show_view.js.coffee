@AL.module 'SearchApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "search/show/templates/show_layout"

    regions:
      headerRegion: "#searchbox"
      resultsRegion: "#results_region_search"

    events: {
      "click .clear-search": "clearSearch"
      "click button": "queryPassages"
    }
    clearSearch: ->
      console.log 'clearSearch'
      # List.Controller.startWorks()
      $("#results_region_search").html('<img src="assets/images/drop-of-thames_320w.png" />
        <br/>A Drop of Thames Water <br/><em>Punch magazine (1850), via Wikimedia Commons</em>')
      $("#q_input").val('')

    queryPassages: (e) =>
      # console.log $(e.currentTarget)
      q = $("#q_input").val()
      Backbone.history.navigate("search/" + q, true)
      # List.Controller.searchPassages($("#q_input").val())


  # TODO: refactor? same functionality elsewhere
  class Show.SearchResult extends App.Views.ItemView
    template: "search/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.placeref": "onPlacerefClick"
      "mouseenter span.place": "onPlacerefEnter"
      "mouseleave span.place": "onPlacerefLeave"
    }
    # highlightPlacerefs: ->
    #   console.log 'Show.Passage.highlightPlacerefs()'

    onPlacerefClick: (e) ->
      # window.context = $(e.currentTarget).context
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefClick', prid
      App.vent.trigger 'placeref:click', {'id': prid}

    onPlacerefEnter: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      # console.log 'highlight placeref #', id
      App.vent.trigger('placeref:highlight', id);
      # App.vent.trigger('placeref:hover', e)

    onPlacerefLeave: (e) ->
      id = this.getPlacerefIdFromEvent(e);
      # console.log 'left placeref span'
      App.vent.trigger('placeref:unhighlight', id);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

  # passages are shown by clicking a work
  class Show.SearchResults extends App.Views.CompositeView
    template: "search/show/templates/_passages"
    childView: Show.SearchResult
    childViewContainer: "div"
