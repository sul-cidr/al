@AL.module "WorksApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "works/list/templates/list_layout"

    regions:
      searchboxRegion: "#searchbox_region_w"
      workListRegion: "#worklist_region_w"

    events: {
      "click .clear": "removeFilter"
    }

    removeFilter: ->
      # console.log 'remove filter'
      $("#selected_cat_works").html('')
      App.request "works:category", 0, (works) =>
        List.Controller.listCatWorks(works)
        App.vent.trigger("map:reset")

  class List.Searchbox extends App.Views.ItemView
    template: "works/list/templates/_searchbox"
    events: {
        "focus #search_input_w": "getAutocomplete"
    }

    getAutocomplete: ->
      # console.log 'getAutocomplete in works'
      $("#search_input_w").autocomplete({
        source: workLookup
        select: (event, ui) ->
            event.preventDefault()
            $("#search_input_w").val(ui.item.label)
            @selectedWork = ui.item.value
            @route = "workpassages/w/" + ui.item.value
            # console.log @route
            Backbone.history.navigate(@route, true)

        focus: (event, ui) ->
            event.preventDefault()
            $("#search_input_w").val(ui.item.label)
      })

  class List.Work extends App.Views.ItemView
    template: "works/list/templates/_work"
    tagName: "span"
    events: {'click a': 'workByRoute'}
    workByRoute: ->
      work = this.model
      route = "workpassages/w/" + work.get('work_id')
      console.log 'List.Work workByRoute', route
      Backbone.history.navigate(route, true)

  class List.Works extends App.Views.CompositeView
    template: "works/list/templates/_works"
    childView: List.Work
    emptyView: List.Empty
    childViewContainer: "div"
    viewComparator: "sorter"

  class List.Empty extends App.Views.ItemView
    template: "works/list/templates/_empty"
    tagName: "p"
