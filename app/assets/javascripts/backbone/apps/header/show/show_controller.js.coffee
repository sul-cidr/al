@AL.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showHeader: ->
      headerView = @getHeaderView()
      App.headerRegion.show headerView

    getHeaderView: ->
      new Show.Header

    displayModal: ->
      alert('what this app is about and who made it')


# HeaderApp.Show.Controller.displayModal()
