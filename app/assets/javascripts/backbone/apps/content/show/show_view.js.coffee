@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.ContentLayout extends App.Views.Layout
    template: "content/show/templates/show_layout"

    regions:
      contentNavRegion: "#content_nav_region"
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
