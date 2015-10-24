@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  App.vent.on "author:show", (author) ->
    console.log "map heard author:show --> API.filterByAuthor"
    API.filterByAuthor author

  App.vent.on "category:authors:show", (cat) ->
    API.filterByCategory cat


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

    # not in use
    # filterForWork: (work) ->
    #   # console.log 'map.API filterForWork()', work.get("work_id")
    #   MapApp.Show.Controller.setFilter 'work', (placeref) ->
    #     placeref.get("work_id") == work.get("work_id")

    focusArea: (area) ->
      # No more hierarchy - one level of areas

      # if area.get("area_type") == "hood"
      #   area = area
      #   parent_id = area.get("parent_id")
      #   # TODO: proper breadcrumbs
      #   console.log 'map focus ' + area.get("name") + '; parent_id:', parent_id
      #   turfpoint = turf.point(wellknown(area.get("geom_wkt")).coordinates)
      #
      #   # make buffer, zoom to it, filter features
      #   buffer = turf.buffer( turfpoint, 1, 'kilometers' )
      #
      #   MapApp.Show.Controller.zoomTo 'hood', swap(turf.centroid(buffer).geometry.coordinates)
      #
      #   @filterByArea "hood", buffer.features[0]
      # else
      MapApp.Show.Controller.zoomTo 'area', area

      bounds = turf.polygon(wellknown(area.get("geom_wkt")).coordinates[0])

      @filterByArea "area", bounds

    filterByArea: (type, bounds) ->
      # to setFilter(area)
      MapApp.Show.Controller.setFilter 'area', (placeref) ->
        turf.inside( turf.point(wellknown(placeref.get("geom_wkt")).coordinates[0]), bounds )

    clearFilters: ->
      $("#place_passages_region").fadeOut("slow")
      MapApp.Show.Controller.clearFilters()
      # map.setView([51.5120, -0.0928], 12)


  # TODO: part of refactoring for areas - single area:show
  App.vent.on "area:focus", (area) ->
    API.focusArea(area)

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
