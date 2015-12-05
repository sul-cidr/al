@AL.module "SearchApp", (SearchApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  # class SearchApp.Router extends Marionette.AppRouter
  #
  # API =
  #   startSearch: ->
  #     console.log 'API.startSearch fired'
  #     AL.SearchApp.Show.Controller.startSearch()
  #
  #
  # SearchApp.on "start", ->
  #   new WorksApp.Router
  #     controller: API
