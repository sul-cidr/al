@AL.module "PlacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "places/list/templates/list_layout"

    regions:
      searchboxRegion: "#searchbox_region"
      navmapRegion: "#navmap_region"
      arealistRegion: "#arealist_region"

  class List.Searchbox extends App.Views.ItemView
    template: "places/list/templates/_searchbox"
    events: {
        "focus #search_input": "getAutocomplete"
        # "click button": "showPlace"
    }

    getAutocomplete: ->
      console.log 'getAutocomplete'
      $("#search_input").autocomplete({
        source: placeLookup
        select: (event, ui) ->
            event.preventDefault()
            $("#search_input").val(ui.item.label)
            # @selectedArea = ui.item.value
            # console.log @selectedArea
            @route = "places/" + ui.item.value
            Backbone.history.navigate(@route, true)

        focus: (event, ui) ->
            event.preventDefault()
            $("#search_input").val(ui.item.label)
      })


  class List.Navmap extends App.Views.ItemView
    template: "places/list/templates/_navmap"


  class List.Area extends App.Views.ItemView
    template: "places/list/templates/_area"
    tagName: "span"
    events: {
      "click a": "areaByRoute"
      "mouseenter a": "onAreaEnter"
      "mouseleave a": "onAreaLeave"
    }

    areaByRoute: ->
      window.activePlace = this.model
      area = this.model
      id = area.get('area_id')
      @route = "places/" + id
      console.log 'areaByRoute(), id: ',id

      Backbone.history.navigate(@route, true)

      # App.vent.trigger('area:unhighlight', id);

    onAreaEnter: (e) ->
      id = this.getAreaIdFromEvent(e);
      # console.log 'mouseover area #', id
      # App.vent.trigger('area:highlight', id);

    onAreaLeave: (e) ->
      id = this.getAreaIdFromEvent(e);
      # console.log 'left area a'
      # App.vent.trigger('area:unhighlight', id);

    getAreaIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

  class List.Areas extends App.Views.CompositeView
    template: "places/list/templates/_areas"
    childView: List.Area
    emptyView: List.Empty
    childViewContainer: "arealist"

  class List.Empty extends App.Views.ItemView
    template: "places/list/templates/_empty"
    tagName: "p"
