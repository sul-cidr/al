@AL.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.Header extends App.Views.ItemView
    template: "header/show/templates/show_header"
    events:
      "click #home_link": "resetApp"
      "click #intro_link": "openSplash"
      "click #about_link": "loadAbout"
      "click #map_chooser li": "loadMap"
      "click i.fa-close": "loadAbout"
      # "click #header_right i": "loadAbout"
      # "click #header_left i": "resetApp"
      # "click #map_chooser li": "loadMap"

    loadAbout: (e)->
      Show.Controller.loadAbout(e)

    openSplash: (e)->
      AL.ContentApp.Show.Controller.openSplash()

    resetApp: ->
      Backbone.history.navigate("/authors")
      window.location.reload()

    loadMap: (e) ->
      id = e.target.attributes.val.value
      App.vent.trigger('map:swap', id);

  class Show.ModalView extends App.Views.ItemView
    template: "header/show/templates/show_modal"
    el: "#modal"
