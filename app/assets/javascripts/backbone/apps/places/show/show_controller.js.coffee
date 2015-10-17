@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    listPlacePassages: (authid) ->
      prefname = authhash[authid]
      # console.log 'back in Show.Controller from vis with', authid

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

    #
    # generates summary by author
    # TODO: by decade
    # TODO: why is this function triggered continually?
    showAreaSummary: (@activePlacerefs) ->
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
        worksYears.push(workhash[p.model.attributes.work_id].pub_year)
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
      # console.log auths
      window.authobj = {"children":[]}
      # console.log authobj
      _.each auths, (a) =>
        authobj['children'].push(a)
      histYears(years)
      packAuths(authobj)

    # generates a list (not in use)
    makeText: (auths) ->
      summaryHtml = "<div class='author-counts'>"
      _.each auths, (a) =>
        summaryHtml += "<span>"+authhash[a.key]+" (" + a.value + ")</span>"
      summaryHtml += "</div>"
      return summaryHtml

    # TODO: needs refactoring--showBorough and showHood to showArea()
    showBorough: (id) ->
      # console.log id
      App.request "area:entity", id, (borough) =>
        # console.log 'ctrlr: got borough', borough.get("id")
        App.request "borough:hoods", id, (hoods) =>
          # console.log "ctrlr: got "+hoods.length+" hoods"
          # let map know

          @areaLayout = @getAreaLayout borough
          @areaLayout.on "show", =>
            # console.log 'areaLayout shown'
            @showTitle borough
            @showNav hoods
            @showPlaceContent borough

            App.vent.trigger "area:focus", borough
          # keep showing in the placesRegion for now; areas are one kind of place
          App.placesRegion.show @areaLayout

    showHood: (id) ->
      App.request "area:entity", id, (hood) =>
        parent = hood.get("parent_id")
        console.log 'ctrlr: got hood ' + hood.get("name") + '; parent is ', hood.get("parent_id")
        # let map know

        @areaLayout = @getAreaLayout hood
        @areaLayout.on "show", =>
          # console.log 'areaLayout shown'
          @showTitle hood
          @showPlaceContent hood

          App.vent.trigger "area:focus", hood
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
