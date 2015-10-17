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
      # console.log passage_ids

      # console.log 'Show.Controller.listWorkPassages() for',work_id
      App.request "passages:places", passage_ids, (place_passages) =>
      #   # wont show/render twice without reset
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        placePassagesView = @getPlacePassagesView place_passages
        # console.log 'listPlacePassages(), '+ place_passages.length +
        #   ' for ' + authhash[authid]
        # console.log place_passages
        # can I get place passages rendering anywhere??
        # @areaLayout.placeContentRegion.show placePassagesView
        App.placePassagesRegion.show placePassagesView
      #   # TODO: show Passages tab if it was hidden
      #   $("#passages_pill").removeClass("hidden")
        $(".passages-places h4").html(authhash[authid])

    getPlacePassagesView: (place_passages) ->
      new Show.PlacePassages ({
        collection: place_passages
        viewComparator: "passage_id"
        className: 'passages-places'
      })

    #
    #
    #
    showAreaSummary: (@activePlacerefs) ->
      window.wPlacerefs = []
      @bPlacerefs = []
      @activeWorksPlaces = _.filter(activePlacerefs, (p) ->
        p.model.attributes.placeref_type == 'work')
      # console.log @activeWorksPlaces
      @activeBioPlaces = _.filter(activePlacerefs, (p) ->
        p.model.attributes.placeref_type == 'bio')
      # crossbio = crossfilter(activeBioPlaces)
      # window.crossworks = crossfilter(activeWorksPlaces)
      console.log 'API.showAreaSummary..triggered from ??'
      _.each @activeWorksPlaces, (p) =>
        wPlacerefs.push(p.model.attributes)
      _.each @activeBioPlaces, (p) =>
        @bPlacerefs.push(p.model.attributes)
      crossworks = crossfilter(wPlacerefs)
      crossbio = crossfilter(@bPlacerefs)
      # console.log 'have crossworks and crossbio array'

      # authById = crossworks.dimension(function(d) { return d.author_id; })
      authById = crossworks.dimension (d) ->
        d.author_id
      window.placerefsByAuthor = authById.group((author_id) ->
        author_id).all()
      # placerefsByAuthor = authById.group(function(author_id){return author_id}).all()

      # $("#place_content_region").html(@makeText placerefsByAuthor)
      $("#place_content_region").html(@makeVis placerefsByAuthor)

    #
    #
    #
    makeVis: (auths) ->
      # console.log auths
      window.authobj = {"children":[]}
      # console.log authobj
      _.each auths, (a) =>
        authobj['children'].push(a)
      packAuths(authobj)

    makeText: (auths) ->
      summaryHtml = "<div class='author-counts'>"

      _.each auths, (a) =>
        summaryHtml += "<span>"+authhash[a.key]+" (" + a.value + ")</span>"
        # console.log authhash[a.key] + ': ' + a.value

      summaryHtml += "</div>"
      # console.log summaryHtml
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
