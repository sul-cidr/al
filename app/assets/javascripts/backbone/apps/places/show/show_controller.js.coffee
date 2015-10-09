@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showBorough: (borough,hoods) ->
      id = borough.get("id")
      name = borough.get("name")
      # console.log 'Show.Controller.showBorough() ',hoods.length
      @areaLayout = @getAreaLayout borough
      window.areaLayout = @areaLayout

      @areaLayout.on "show", =>
        # console.log 'areaLayout shown'
        @showTitle borough
        @showNav hoods
        @showPlaceContent borough

      # keep showing in the placesRegion for now; areas are one kind of place
      App.placesRegion.show @areaLayout

    getAreaLayout: (area) ->
      new Show.Layout ({
        model: area
      })

    showTitle: (area) ->
      # console.log 'in showTitle', area.get("name")
      titleView = @getTitleView area
      @areaLayout.titleRegion.show titleView

    getTitleView: (area) ->
      new Show.Title
        model: area

    showNav: (hoods) ->
      @navView = @getNavView hoods
      @areaLayout.navRegion.show @navView

    getNavView: (hoods) ->
      new Show.Hoods
        collection: hoods

    # CHECK: this could be split out, depending on content
    showPlaceContent: (area) ->
      # console.log 'showPlaceContent', area
      @contentView = @getContentView area
      @areaLayout.placeContentRegion.show @contentView

    getContentView: (area) ->
      new Show.Content
        model: area
