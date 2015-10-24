@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startContent: ->
      @contentLayout = @getContentLayout()

      App.contentRegion.show @contentLayout

    getContent: ->
      new Show.ContentLayout

    getContentLayout: ->
      new Show.ContentLayout

    startAuthors: ->
      # get a view and show in authorsRegion
      # console.log 'Show.Controller.startAuthors'

    startPlaces: ->
      # get a view and show in placesRegion
      # console.log 'Show.Controller.startPlaces'
