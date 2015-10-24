@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.ContentLayout extends App.Views.Layout
    template: "content/show/templates/show_layout"

    regions:
      contentNavRegion: "#content_nav_region"
      contentRegion: "#content_region"
      authorsRegion: "#authors_region"
      placesRegion: "#places_region"

    events:
      "click #content_nav_region li": "loadContent"

    loadContent: (e) ->
      $("#content_nav_region li").removeClass("active")
      # $(".nav-pills li").removeClass("active")
      $(e.currentTarget).addClass("active")
      # $(".regiondiv").fadeToggle(500)
      # authid = App.request("author:model").get("author_id")
      @pill = $(e.currentTarget).context.attributes.value.value
      if @pill == 'authors'
        @route = "#authors"
        $("#places_region").hide()
        $("#authors_region").fadeIn("slow")
        # AL.AuthorsApp.List.Controller.startAuthors()
        # console.log 'loadContent, works:', @route
        # CHECK: is this Navigate...true right?
        # Backbone.history.navigate(@route, true)
      else if @pill == 'places'
        @route = "#places"
        $("#authors_region").hide()
        $("#places_region").fadeIn("slow")
        # AL.PlacesApp.List.Controller.startPlaces()
        # console.log 'loadContent, bio:', @route
        # Backbone.history.navigate(@route, true)
