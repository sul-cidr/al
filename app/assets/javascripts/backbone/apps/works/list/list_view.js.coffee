@AL.module "WorksApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "works/list/templates/list_layout"

    regions:
      headerRegion: "#title_region_w"
      dimensionsRegion: "#dimensions_region_w"
      categoriesRegion: "#categories_region_w"
      workListRegion: "#worklist_region_w"

    events: {
      "click .clear": "removeFilter"
    }
    removeFilter: ->
      console.log 'removeFilter'
      # List.Controller.startWorks()
      $("#selected_cat_works").html('')
      App.request "works:category", 0, (works) =>
        List.Controller.listCatWorks(works)
      #   App.vent.trigger("map:reset")

  class List.Title extends App.Views.ItemView
    template: "works/list/templates/_title"
    events: {
      "click button": "queryPassages"
    }
    queryPassages: (e) =>
      # console.log $(e.currentTarget)
      q = $("#q_input").val()
      Backbone.history.navigate("search/" + q, true)
      # List.Controller.searchPassages($("#q_input").val())

  class List.Dimensions extends App.Views.ItemView
    template: "works/list/templates/_dimensions"
    # TODO on-click filter categories
    events: {
      "click #dimension_pills_w li": "filterCats"
    }
    filterCats: (e) =>
      $("#dimension_pills_w li").removeClass("active")
      $(e.currentTarget).addClass("active")
      dim = $(e.currentTarget).context.attributes.value.value
      # console.log 'List.Dimensions.filterCats by dimension: ' + dim
      List.Controller.listCategories(dim)

  class List.Work extends App.Views.ItemView
    template: "works/list/templates/_work"
    tagName: "span"
    events: {'click a': 'workByRoute'}
    workByRoute: ->
      work = this.model
      route = "workpassages/w/" + work.get('work_id')
      # console.log 'List.Work workByRoute', work
      Backbone.history.navigate(route, true)

  class List.Works extends App.Views.CompositeView
    template: "works/list/templates/_works"
    childView: List.Work
    emptyView: List.Empty
    childViewContainer: "div"

  class List.Category extends App.Views.ItemView
    template: "works/list/templates/_category"
    tagName: "li"
    # events: {"click": "filterWorks"}
    events: {
      "click li.category": "filterWorks"
    }
    filterWorks: (e) ->
      seltext =
        '<span class="strong">'+
        $(e.currentTarget).context.innerHTML +
        '</span><span class="right crumb clear">'+
        'Clear filter</span>'
      $("#selected_cat_works").html(seltext)

      cat = this.model
      id = cat.attributes.id
      # console.log 'filter for cat', id
      # get a collection of work models for category
      App.request "works:category", id, (works) =>
        List.Controller.listCatWorks(works)
        # console.log 'works for cat '+id, works
      # trigger picked up by map_app
      # App.vent.trigger "category:works:show", cat
      App.reqres.setHandler "category:active", ->
        return cat

  class List.Categories extends App.Views.CompositeView
    template: "works/list/templates/_categories"
    className: 'categories'
    childView: List.Category
    childViewContainer: ".catlist"
    # events: {
    #   "click #selected_cat_works a": "removeFilter"
    # }

    filter: (child, index, collection) ->
      # filter genre for initial display
      child.get('dim') == 'genre'

    # removeFilter: (e) ->
    #   # console.log 'remove filter'
    #   $("#selected_cat_works").remove()
    #   App.request "works:category", 0, (works) =>
    #     List.Controller.listCatWorks(works, 0)
    #     App.vent.trigger("map:reset")


  class List.Empty extends App.Views.ItemView
    template: "works/list/templates/_empty"
    tagName: "p"
