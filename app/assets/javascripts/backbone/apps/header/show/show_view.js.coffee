@AL.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.Header extends App.Views.ItemView
    template: "header/show/templates/show_header"
    events:
      "click .header-right": "bigModal"

    bigModal: (e) ->
      Show.Controller.displayModal()

  class Show.ModalView extends App.Views.ItemView
    template: "header/show/templates/show_modal"
    el: "#modal"
