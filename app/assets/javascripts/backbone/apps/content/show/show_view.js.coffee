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
        console.log 'content.showTab', @tab
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
      tab = window.location.hash.substring(1,window.location.hash.length)
      catid = parseInt($(e.currentTarget).context.attributes.val.value)
      # print category header
      seltext =
        '<span class="strong">'+
        $(e.currentTarget).context.innerHTML +
        '</span><span class="right crumb clear">'+
        'Clear filter</span>'
      $("#selected_cat_"+tab).html(seltext)

      # get a collection of models for category
      App.request tab+":category", catid, (collection) =>
        # console.log 'filtered '+ tab + ', cat: '+ catid, collection
        if tab == 'works'
          AL.WorksApp.List.Controller.listCatWorks(collection)
        else if tab == 'authors'
          AL.AuthorsApp.List.Controller.listCatAuthors(collection)

      # to map_app
      App.vent.trigger "category:"+tab+":show", catid

    filterWorks: (e) ->
      # console.log 'filterWorks(e) from ContentApp.Show'
      window.catid = parseInt($(e.currentTarget).context.attributes.val.value)
      # filter works and map for category
      seltext =
        '<span class="strong">'+
        $(e.currentTarget).context.innerHTML +
        '</span><span class="right crumb clear">'+
        'Clear filter</span>'
      $("#selected_cat_works").html(seltext)

      # get a collection of work models for category
      App.request "works:category", catid, (works) =>
        # console.log 'filtered works: '+ catid, works
        AL.WorksApp.List.Controller.listCatWorks(works)

      # to map_app
      App.vent.trigger "category:works:show", catid

    filterAuthors: (e) ->
      # console.log 'filterWorks(e) from ContentApp.Show'
      window.catid = parseInt($(e.currentTarget).context.attributes.val.value)
      # filter authors and map for category
      seltext =
        '<span class="strong">'+
        $(e.currentTarget).context.innerHTML +
        '</span><span class="right crumb clear">'+
        'Clear filter</span>'
      $("#selected_cat_authors").html(seltext)

      # get a collection of author models for category
      App.request "authors:category", catid, (authors) =>
        # console.log 'filtered authors: '+ catid, authors
        AL.AuthorsApp.List.Controller.listCatAuthors(authors)

      # to map_app
      App.vent.trigger "category:authors:show", catid
      # App.vent.trigger "category:authors:show", cat
