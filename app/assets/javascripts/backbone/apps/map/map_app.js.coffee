@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  App.vent.on "author:show", (author) ->
    console.log "map heard author:show -->", author
    # placerefs for all passages by an author
    API.filterByAuthor author

  App.vent.on "category:authors:show", (cat) ->
    console.log 'map heard category:authors:show --> ', cat
    # placerefs for all passages by set of authors
    API.filterByCategory cat

  App.vent.on "category:works:show", (cat) ->
    console.log 'map heard category:works:show --> ', cat
    # placerefs for all passages in works of a category
    # API.filterByCategory cat

  App.vent.on "place:focus", (area) ->
    API.focusPlace(area)

  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

    filterByAuthor: (author) ->
      console.log  'API.filterByAuthor()',author.get("author_id")
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        placeref.get("author_id") == author.get("author_id")

    filterByAuthors: (author_ids, id) ->
      # console.log author.get("author_id")
      MapApp.Show.Controller.setFilter 'authors', (placeref) ->
        author_ids.indexOf(placeref.get("author_id")) > -1

    filterByCategory: (cat) ->
      # build collection of authors having 'cat'
      id = cat.get("id")
      author_ids = []
      App.request "authors:category", id, (authors) =>
        # console.log authors
        _.each authors.models, (a) =>
          author_ids.push a.get("author_id")
          @filterByAuthors author_ids, id
        console.log 'mapping cat '+id+ ': ', author_ids

    focusPlace: (area) ->
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

    resetMap: ->
      # close the place passages window
      $("#place_passages_region").fadeOut("slow")
      # clear all filters
      MapApp.Show.Controller.clearFilters()


  # TODO: part of refactoring for areas - single area:show

  App.vent.on "map:reset", ->
    API.resetMap()

  App.vent.on "work:show", (work) ->
    API.filterForWork work

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


  MapApp.on "start", ->
    controller: API
    API.showMap()
