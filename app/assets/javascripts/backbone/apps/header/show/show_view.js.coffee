@AL.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.Header extends App.Views.ItemView
    template: "header/show/templates/show_header"
    events:
      "click .header-right": "loadAbout"
      "click i": "resetApp"
      "click #map_chooser li": "loadMap"

    loadAbout: (e)->
      Show.Controller.loadAbout(e)

    resetApp: (e) ->
      Backbone.history.navigate("authors", true)

    loadMap: (e) ->
      id = e.target.attributes.val.value
      # console.log 'loadMap (e)', id
      App.vent.trigger('map:swap', id);

  class Show.ModalView extends App.Views.ItemView
    template: "header/show/templates/show_modal"
    el: "#modal"
