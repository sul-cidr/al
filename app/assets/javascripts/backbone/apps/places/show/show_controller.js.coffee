@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    listPlacePassages: (authid) ->
      console.log 'listPlacePassages() for', authid
      prefname = authHash[authid]

      window.authorPlacerefs =
        _.filter @activePlacerefs.models, (pr) =>
          pr.attributes.placeref.author_id == authid

      # get passage_ids for author
      window.passage_ids = []
      _.each authorPlacerefs, (p) =>
        # console.log 'p',p
        passage_ids.push p.attributes.placeref.passage_id

      # retrieve single author's passages for an area
      App.request "passages:place", passage_ids, (place_passages) =>
        # if App.authorContentRegion.$el.length > 0
        #   App.authorContentRegion.reset()
        window.placepassages = place_passages
        placePassagesView = @getPlacePassagesView place_passages

        App.placePassagesRegion.show placePassagesView
        $("#place_passages_region").removeClass('hidden')
        # App.placePassagesRegion.$el.fadeIn("slow")
        #
        $(".passages-places h4").html(authHash[authid])

    getPlacePassagesView: (place_passages) ->
      new Show.PlacePassages ({
        collection: place_passages
        viewComparator: "passage_id"
        className: 'passages-places'
      })

    showPlace: (id) ->
      console.log 'showPlace(id)', id

      App.request "area:entity", id, (area) =>
        App.request "placeref:entities", {area_id:id}, (activePlacerefs) =>
          console.log 'showPlace() placerefs', activePlacerefs
          window.activeplacerefs = activePlacerefs
          @showPlaceSummary activePlacerefs
        # get placerefs within area,
        # then App.vent.trigger "placerefs:area" {activePlacerefs}
        # that will run showPlaceSummary() below
        # console.log 'showPlace(id) asked for model', area
        @placeLayout = @getPlaceLayout area
        @placeLayout.on "show", =>
          # console.log 'areaLayout shown'
          @showTitle area
          @showPlaceContent area

          # for map
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

    # renders template with area keywords field
    showPlaceContent: (area) ->
      # console.log 'showPlaceContent', area
      @contentView = @getContentView area
      @placeLayout.placeContentRegion.show @contentView

    getContentView: (area) ->
      new Show.Content
        model: area

    # generates summary by author
    # TODO: by decade
    showPlaceSummary: (activePlacerefs) ->
      # console.log 'showPlaceSummary() activePlacerefs', activePlacerefs
      @activePlacerefs = activePlacerefs
      window.wPlacerefs = []
      window.worksYears = []
      @bPlacerefs = []
      _.each activePlacerefs.models, (p) =>
        # console.log 'activePlacerefs', p
        wPlacerefs.push(p.attributes.placeref)
        worksYears.push(p.attributes.work.work_year)

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
    # run vis.js packAuths bubble chart and temporal histogram
    #
    makeVis: (auths, years) ->
      # console.log years
      window.authobj = {"children":[]}
      # console.log authobj
      _.each auths, (a) =>
        authobj['children'].push(a)
      histYears(years)
      packAuths(authobj)
