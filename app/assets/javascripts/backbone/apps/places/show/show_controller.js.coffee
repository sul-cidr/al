@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =
    # TODO: needs refactoring--showBorough and showHood to showArea()
    showBorough: (id) ->
      App.request "area:entity", id, (borough) =>
        console.log 'ctrlr: got borough', borough.get("id")
        App.request "borough:hoods", id, (hoods) =>
          console.log "ctrlr: got "+hoods.length+" hoods"
          App.vent.trigger "area:show", borough

          @areaLayout = @getAreaLayout borough
          @areaLayout.on "show", =>
            # console.log 'areaLayout shown'
            @showTitle borough
            @showNav hoods
            @showPlaceContent borough

          # keep showing in the placesRegion for now; areas are one kind of place
          App.placesRegion.show @areaLayout


    showHood: (id) ->
      App.request "area:entity", id, (hood) =>
        parent = hood.get("parent_id")
        console.log 'showHood, parentid: ' + hood.get("name"), hood.get("parent_id")
        App.vent.trigger "area:show", hood

        @areaLayout = @getAreaLayout hood
        @areaLayout.on "show", =>
          # console.log 'areaLayout shown'
          @showTitle hood
          @showPlaceContent hood

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
