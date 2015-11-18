@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    listPlacePassages: (authid) ->
      prefname = authhash[authid]

      window.authorPassages =
        _.filter @activeWorksPlaces, (wp) =>
          wp.model.attributes.author_id == authid

      # get passage_ids for author
      window.passage_ids = []
      _.each authorPassages, (p) =>
        passage_ids.push p.model.attributes.passage_id

      # retrieve single author's passages for an area
      App.request "passages:places", passage_ids, (place_passages) =>
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        window.placepassages = place_passages
        placePassagesView = @getPlacePassagesView place_passages

        App.placePassagesRegion.show placePassagesView
        App.placePassagesRegion.$el.fadeIn("slow")
        #
        $(".passages-places h4").html(authhash[authid])

    getPlacePassagesView: (place_passages) ->
      new Show.PlacePassages ({
        collection: place_passages
        viewComparator: "passage_id"
        className: 'passages-places'
      })

    # triggers area:focus to get placerefs for area
    showPlace: (id) ->
      console.log 'place:focus triggered', id
      App.request "area:entity", id, (area) =>

        @placeLayout = @getPlaceLayout area
        @placeLayout.on "show", =>
          # console.log 'areaLayout shown'
          @showTitle area
          @showPlaceContent area

          App.vent.trigger "place:focus", area
          # CHECK: expose current area model here?
          App.reqres.setHandler "area:model", ->
              return area
      # keep showing in the placesRegion for now; areas are one kind of place
      App.placesRegion.show @placeLayout


    getPlaceLayout: (area) ->
      new Show.Layout ({
        model: area
      })

    showTitle: (area) ->
      # console.log 'in showTitle', area.get("name")
      titleView = @getTitleView area
      @placeLayout.titleRegion.show titleView

    getTitleView: (area) ->
      new Show.Title
        model: area

    # CHECK: this could be split out, depending on content
    showPlaceContent: (area) ->
      # console.log 'showPlaceContent', area
      @contentView = @getContentView area
      @placeLayout.placeContentRegion.show @contentView

    getContentView: (area) ->
      new Show.Content
        model: area

    #
    # generates summary by author
    # TODO: by decade
    # TODO: why is this function triggered continually?
    showPlaceSummary: (activePlacerefs) ->
      window.wPlacerefs = []
      window.worksYears = []
      @bPlacerefs = []
      @activeWorksPlaces = _.filter(activePlacerefs, (p) ->
        p.model.attributes.placeref_type == 'work')
      # console.log @activeWorksPlaces
      @activeBioPlaces = _.filter(activePlacerefs, (p) ->
        p.model.attributes.placeref_type == 'bio')

      # console.log 'API.showAreaSummary..triggered from ??'
      _.each @activeWorksPlaces, (p) =>
        wPlacerefs.push(p.model.attributes)
        worksYears.push(workhash[p.model.attributes.work_id].work_year)
      _.each @activeBioPlaces, (p) =>
        @bPlacerefs.push(p.model.attributes)
      crossworks = crossfilter(wPlacerefs)
      crossbio = crossfilter(@bPlacerefs)
      # console.log 'have crossworks and crossbio array'

      authById = crossworks.dimension (d) ->
        d.author_id
      window.placerefsByAuthor = authById.group((author_id) ->
        author_id).all()

      # render the bubble vis
      $("#place_content_region").html(@makeVis placerefsByAuthor, worksYears)

    #
    # run vis.js packAuths bubble chart
    #
    makeVis: (auths, years) ->
      console.log years
      window.authobj = {"children":[]}
      # console.log authobj
      _.each auths, (a) =>
        authobj['children'].push(a)
      packAuths(authobj)
      histYears(years)

    # showNav: (hoods) ->
    #   @navView = @getNavView hoods
    #   @areaLayout.navRegion.show @navView
    #
    # getNavView: (hoods) ->
    #   new Show.Hoods
    #     collection: hoods

    #
    # showHood: (id) ->
    #   App.request "area:entity", id, (hood) =>
    #     parent = hood.get("parent_id")
    #     console.log 'ctrlr: got hood ' + hood.get("name") + '; parent is ', hood.get("parent_id")
    #     # let map know
    #
    #     @areaLayout = @getAreaLayout hood
    #     @areaLayout.on "show", =>
    #       # console.log 'areaLayout shown'
    #       @showTitle hood
    #       @showPlaceContent hood
    #
    #       App.vent.trigger "area:focus", hood
    #     # keep showing in the placesRegion for now; areas are one kind of place
    #     App.placesRegion.show @areaLayout
