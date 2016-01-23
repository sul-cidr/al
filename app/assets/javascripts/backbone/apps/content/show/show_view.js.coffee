@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.ContentLayout extends App.Views.Layout
    template: "content/show/templates/show_layout"

    regions:
      contentNavRegion: "#content_nav_region"
      dimensionsRegion: "#dimensions_region"
      contentRegion: "#content_region"
      authorsRegion: "#authors_region"
      placesRegion: "#places_region"
      worksRegion: "#works_region"
      searchRegion: "#search_region"
      mapChooser: "#map_chooser"

    events:
      "click #content_nav_region li": "showTab"

    showTab: (e) ->
      if ['authors','places','works','search'].indexOf(e) > -1
        @tab = e
      else
        @tab = $(e.currentTarget).context.attributes.value.value
        # console.log 'content.showTab', @tab
        $(e.currentTarget).addClass("active")
      window.activeTab = @tab
      Show.Controller.showTab(@tab)

  class Show.Dimensions extends App.Views.ItemView
    template: "content/show/templates/_dimensions"
    # TODO on-select for each dropdown
    events: {
      # TODO: needs to filter works, alternatively
      "click .dim-container li": "filterStuff"
    }
    filterStuff: (e) ->
      # filter either authors or works and map for category
      listFilter = {clear:true}
      # mapFilter = {clear:true}
      dim = $(e.currentTarget).context.parentElement.id.substring(3,)
      tab = window.location.hash.substring(1,window.location.hash.length)
      catid = parseInt($(e.currentTarget).context.attributes.val.value)
      console.log 'filterStuff() ' + tab, dim, catid
      # print category header
      seltext =
        '<span class="strong">'+
        $(e.currentTarget).context.innerHTML +
        '</span><span class="right crumb clear">Clear filter</span>'
      $("#selected_cat_"+tab).html(seltext)

      # TODO: refactor
      # get a collection of work or author models for category
      # console.log 'filterStuff '+ tab+":category" + ', cat: '+ catid
      if ['genre', 'form'].indexOf(dim) >= 0
        listFilter['work_cat'] = catid
      else # if ['community', 'standing'].indexOf(dim) >= 0
        listFilter['auth_cat'] = catid
      if tab == 'works'
        App.request tab+":category", listFilter, (collection) =>
          console.log 'filter ', listFilter, collection
          AL.WorksApp.List.Controller.listCatWorks(collection)
      else if tab == 'authors'
        App.request tab+":category", listFilter, (collection) =>
          console.log 'filter ', listFilter, collection
          AL.AuthorsApp.List.Controller.listCatAuthors(collection)

      # to map_app
      # MapApp.Show.Controller.filterPlaces(filter)
      # -> @mapView.renderPlaces(params)
      # mapFilter[dim+'_id'] = catid
      console.log "category:show to map", listFilter
      App.vent.trigger "category:show", (listFilter)
