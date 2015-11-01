@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  App.vent.on "author:show", (author) ->
    console.log "map heard author:show --> API.filterByAuthor"
    API.filterByAuthor author

  App.vent.on "category:authors:show", (cat) ->
    API.filterByCategory cat

  App.vent.on "area:focus", (area) ->
    API.focusArea(area)

  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

    filterByAuthor: (author) ->
      console.log  'API.filterByAuthor() sets filter'
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        placeref.get("author_id") == author.get("author_id")

    filterByAuthors: (author_ids, id) ->
      # console.log author.get("author_id")
      MapApp.Show.Controller.setFilter 'authors', (placeref) ->
        author_ids.indexOf(placeref.get("author_id")) > -1

    filterByCategory: (cat) ->
      # build collection of authorhs having 'cat'
      id = cat.get("id")
      author_ids = []
      App.request "authors:category", id, (authors) =>
        # console.log authors
        _.each authors.models, (a) =>
          author_ids.push a.get("author_id")
          @filterByAuthors author_ids, id
        # console.log 'cat '+id+ ': ', author_ids

    focusArea: (area) ->
      #
      # area model in list has been clicked, need to
      # 1) zoom to its voronoi extents
      # 2) get resulting viewport extents\
      # 3) filter placerefs for viewport w/o filtering map
      #
      # hbounds = hood voronoi, mbounds = markers, vbounds = viewport
      window.area = area
      window.hbounds = turf.polygon(wellknown(area.get("geom_poly_wkt")).coordinates)
      console.log 'hbounds from this:', wellknown(area.get("geom_poly_wkt")).coordinates

      MapApp.Show.Controller.zoomTo 'area', area

      # run this to filter on hood voronoi bounds...
      # or comment and let Show.Controller.zoomTo initiate filtering on viewport\
      MapApp.Show.Controller.filterByArea "area", hbounds

    clearFilters: ->
      $("#place_passages_region").fadeOut("slow")
      MapApp.Show.Controller.clearFilters()


  # TODO: part of refactoring for areas - single area:show
  App.vent.on "work:show", (work) ->
    API.filterForWork work

  App.vent.on "map:reset", ->
    API.clearFilters()

  App.vent.on "placeref:highlight", (id) ->
    # console.log 'map_app heard highlight id#', id
    MapApp.Show.Controller.onHighlightFeature 'placeref', id

  App.vent.on "placeref:unhighlight", (id) ->
    # console.log 'map_app heard unhighlight, id#', id
    MapApp.Show.Controller.onUnhighlightFeature 'placeref', id

  App.vent.on "area:highlight", (id) ->
    # console.log 'map_app heard highlight id#', id
    MapApp.Show.Controller.onHighlightFeature 'area', id

  App.vent.on "area:unhighlight", (id) ->
    # console.log 'map_app heard unhighlight, id#', id
    MapApp.Show.Controller.onUnhighlightFeature 'area', id

  App.vent.on "area:unhighlightAll", ->
    MapApp.Show.Controller.unhighlightAll()

  App.vent.on "authors-panel:close", ->
    # CHECK: dunno what for

  MapApp.on "start", ->
    controller: API
    API.showMap()
