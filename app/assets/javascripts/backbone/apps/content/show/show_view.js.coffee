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

    events:
      "click #content_nav_region li": "showTab"

    showTab: (e) ->
      if ['authors','places','works'].indexOf(e) > -1
        @tab = e
      else
        @tab = $(e.currentTarget).context.attributes.value.value
        $(e.currentTarget).addClass("active")

      Show.Controller.showTab(@tab)

  class Show.Dimensions extends App.Views.ItemView
    template: "content/show/templates/_dimensions"
    # TODO on-select for each dropdown
    events: {
      # TODO: needs to filter works, alternatively
      "click .dim-container li": "filterAuthors"
    }

    filterWorks: (e) ->
      console.log 'filterWorks(e) from ContentApp.Show'

    filterAuthors: (e) ->
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
        console.log 'filtered authors: '+ catid, authors
        List.Controller.listCatAuthors(authors)

      # to map_app
      App.vent.trigger "category:authors:show", catid
      # App.vent.trigger "category:authors:show", cat
