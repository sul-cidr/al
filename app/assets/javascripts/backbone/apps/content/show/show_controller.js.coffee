@AL.module "ContentApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    startContent: ->
      @contentLayout = @getContentLayout()
      # start with authors
      # if $("#authors_region").html() == ''
      #   AL.AuthorsApp.List.Controller.startAuthors()
      # AL.PlacesApp.List.Controller.startPlaces()
      # AL.WorksApp.List.Controller.startWorks()
      App.contentRegion.show @contentLayout

    getContent: ->
      new Show.ContentLayout

    getContentLayout: ->
      new Show.ContentLayout

    # TODO: refactor passages for authors, places, works
    # listPassages: (authid) ->
    #   prefname = authhash[authid]
    #   # console.log 'back in Show.Controller from vis with', authid
    #
    #   authorPassages =
    #     _.filter @activeWorksPlaces, (wp) =>
    #       wp.model.attributes.author_id == authid
    # 
    #   # get passage_ids for author
    #   passage_ids = []
    #   _.each authorPassages, (p) =>
    #     passage_ids.push p.model.attributes.passage_id
    #
    #   # retrieve single author's passages for an area
    #   App.request "passages:places", passage_ids, (place_passages) =>
    #     if App.authorContentRegion.$el.length > 0
    #       App.authorContentRegion.reset()
    #     passagesView = @getPassagesView passages
    #
    #     App.placePassagesRegion.show passagesView
    #     App.placePassagesRegion.$el.fadeIn("slow")
    #     #
    #     $(".passages-places h4").html(authhash[authid])
    #
    # getPassagesView: (passages) ->
    #   new Show.Passages ({
    #     collection: passages
    #     viewComparator: "passage_id"
    #     # TODO: different styles
    #     className: 'passages-places'
    #   })

    showTab: (tab)->
      console.log 'showTab(): ',tab
      $("#content_nav_region li").removeClass("active")

      if tab == 'authors'
        @route = "authors"
        $("#authors_tab").addClass("active")
        $("#places_region").hide()
        $("#works_region").hide()
        $("#authors_region").fadeIn("slow")

      else if tab == 'places'
        if $("#places_region").html() == ''
          AL.PlacesApp.List.Controller.startPlaces()
        @route = "places"
        $("#places_tab").addClass("active")
        $("#authors_region").hide()
        $("#works_region").hide()
        $("#places_region").show()

      else if tab == 'works'
        if $("#works_region").html() == ''
          AL.WorksApp.List.Controller.startWorks()
        @route = "works"
        $("#works_tab").addClass("active")
        $("#authors_region").hide()
        $("#places_region").hide()
        $("#works_region").fadeIn("slow")

      Backbone.history.navigate(@route)

    startAuthors: ->
      # get a view and show in authorsRegion
      # console.log 'Show.Controller.startAuthors'

    startPlaces: ->
      # get a view and show in placesRegion
      # console.log 'Show.Controller.startPlaces'
