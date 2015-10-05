@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showArea: (area) ->
      id = area.get("id")
      name = area.get("name")
      console.log 'Show.Controller.showArea() '+ id,name
      @areaLayout = @getAreaLayout area
      window.areaLayout = @areaLayout

      @areaLayout.on "show", =>
        console.log 'areaLayout shown'
        @showTitle area
        @showNav area
        @showPlaceContent area

      # keep showing in the placesRegion for now; areas are one kind of place
      App.placesRegion.show @areaLayout

    getAreaLayout: (area) ->
      new Show.Layout ({
        model: area
      })

    showTitle: (area) ->
      console.log 'in showTitle', area.get("name")
      titleView = @getTitleView area
      @areaLayout.titleRegion.show titleView

    getTitleView: (area) ->
      new Show.Title
        model: area

    showNav: (area) ->
      @navView = @getNavView area
      @areaLayout.navRegion.show @navView

    getNavView: (area) ->
      new Show.Nav
        model: area

    # CHECK: this could be split out, depending on content
    showPlaceContent: (area) ->
      @contentView = @getContentView area
      @areaLayout.placeContentRegion.show @contentView

    getContentView: (area) ->
      new Show.Content
        model: area
