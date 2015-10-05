@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "places/show/templates/show_layout"
    regions:
      titleRegion: "#place_title_region"
      navRegion: "#place_nav_region"
      placeContentRegion: "#place_content_region"

  class Show.Title extends App.Views.ItemView
    template: "places/show/templates/_title"
    events:
      "click .toggle-places": "onToggle"
      "click .crumb": "goHome"

    # TODO: this is replicated in List.AuthorLayout and in Places
    onToggle: ->
      console.log 'toggle from Show.Title'
      if $("#places-region").offset().left == 0
        $("#places-region").animate { 'left': -($("#places-region").width() - 15) }, 500
      else if $("#places-region").offset().left < 0
        $("#places-region").animate { 'left': 0 }, 500
    goHome: ->
      Backbone.history.navigate("", true)

  class Show.Nav extends App.Views.ItemView
    template: "places/show/templates/_nav"

  class Show.Content extends App.Views.ItemView
    template: "places/show/templates/_content"
