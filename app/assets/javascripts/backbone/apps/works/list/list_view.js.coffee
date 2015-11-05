@AL.module "WorksApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "works/list/templates/list_layout"

    regions:
      headerRegion: "#title_region_w"
      dimensionsRegion: "#dimensions_region_w"
      categoriesRegion: "#categories_region_w"
      worklistRegion: "#worklist_region_w"

  class List.Title extends App.Views.ItemView
    template: "works/list/templates/_title"

  class List.Dimensions extends App.Views.ItemView
    template: "works/list/templates/_dimensions"
    # TODO on-click filter categories
    events: {
      "click #dimension_pills li": "filterCats"
    }
    filterCats: (e) =>
      $("#dimension_pills li").removeClass("active")
      $(e.currentTarget).addClass("active")
      dim = $(e.currentTarget).context.attributes.value.value
      # console.log 'List.Dimensions.filterCats by dimension: ' + dim
      List.Controller.listCategories(dim)

  class List.Work extends App.Views.ItemView
    template: "works/list/templates/_work"
    tagName: "span"
    # events: {'click a': 'authByRoute'}
    # authByRoute: ->
    #   $activeWork = this.model
    #   # console.log $activeWork
    #   work = this.model
    #   # CHECK: Sulc says this is bad...
    #   Backbone.history.navigate("works/"+work.get('work_id'), true)

  class List.Works extends App.Views.CompositeView
    template: "works/list/templates/_works"
    childView: List.Work
    emptyView: List.Empty
    childViewContainer: "div"

  class List.Category extends App.Views.ItemView
    template: "works/list/templates/_category"
    tagName: "span"
    # events: {"click": "filterWorks"}
    events: {
      "click a.category": "filterWorks"
    }

    filterWorks: (e) ->
      # select a category, filter works and map

      # set up 'clear"'
      seltext =
        '<span class="strong">'+
        $(e.currentTarget).context.innerHTML +
        '</span><span class="right crumb"><a href="#">Clear filter</a></span>'
      $("#selected_cat").html(seltext)


      cat = this.model
      id = cat.attributes.id
      console.log 'filter for cat', id
      # get a collection of work models for category
      App.request "works:category", id, (works) =>
        List.Controller.listCatWorks(works, id)

      # trigger picked up by map_app
      App.vent.trigger "category:works:show", cat
      App.reqres.setHandler "category:active", ->
        return cat

  class List.Categories extends App.Views.CompositeView
    template: "works/list/templates/_categories"
    className: 'categories'
    childView: List.Category
    childViewContainer: "#catlist"
    events: {
      "click #selected_cat a": "removeFilter"
    }
    filter: (child, index, collection) ->
      # filter genre for initial display
      child.get('dim') == 'genre'
    onChildviewWorksFiltered: ->
      # console.log 'bubbled up to List.Categories view'
    removeFilter: (e) ->
      # console.log 'remove filter'
      $("#selected_cat").remove()
      App.request "works:category", 0, (works) =>
        List.Controller.listCatWorks(works, 0)
        App.vent.trigger("map:reset")

  class List.Empty extends App.Views.ItemView
    template: "works/list/templates/_empty"
    tagName: "p"
