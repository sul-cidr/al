@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  # @startWithParent = false

  # // Set up the handler
  # App.commands.setHandler 'setFilter', (key, evaluator) ->
  #   API.setFilter key, evaluator

  App.vent.on "author:show", (author) ->
    API.filterByAuthor author

  # TODO: part of refactoring for areas - single area:show
  App.vent.on "area:show", (area) ->
    API.focusArea area

  App.vent.on "category:authors:show", (cat) ->
    API.filterByCategory cat

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

  App.vent.on "authors-panel:close", ->


  API =
    showMap: ->
      MapApp.Show.Controller.showMap()

    toGeoJson: (feature) ->

    focusArea: (area) ->
      if area.get("area_type") == "hood"
        window.area = area
        console.log 'clicked a hood,', area.get("name")
        window.turfpoint = turf.point(wellknown(area.get("geom_wkt")).coordinates)
        console.log 'hood coords', turfpoint
        # make buffer and zoom to it
        window.buffer = turf.buffer( turfpoint, 1, 'kilometers' )
        console.log 'buffer area', turf.area(buffer)

        # MapApp.Show.Controller.zoomTo 'hood', c

        # filter
        MapApp.Show.Controller.setFilter 'area', (placeref) ->
          turf.inside( turf.point(wellknown(placeref.get("geom_wkt")).coordinates[0]), buffer.features[0] )

      else
        MapApp.Show.Controller.zoomTo 'borough', area

        # created spatial filter
        bounds = turf.polygon(wellknown(area.get("geom_wkt")).coordinates[0])
        # window.wkb = wellknown(area.get("geom_wkt"))
        MapApp.Show.Controller.setFilter 'area', (placeref) ->
          turf.inside( turf.point(wellknown(placeref.get("geom_wkt")).coordinates[0]), bounds )

    filterByAuthor: (author) ->
      # on click feed selected author to setFilter(author)
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        placeref.get("author_id") == author.get("author_id")

    filterByAuthors: (author_ids, id) ->
      # console.log author.get("author_id")
      MapApp.Show.Controller.setFilter 'author', (placeref) ->
        author_ids.indexOf(placeref.get("author_id")) > 0

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

    filterForWork: (work) ->
      # console.log 'map.API filterForWork()', work.get("work_id")
      MapApp.Show.Controller.setFilter 'work', (placeref) ->
        placeref.get("work_id") == work.get("work_id")

    clearFilters: ->
      MapApp.Show.Controller.clearFilters()
      map.setView([51.5120, -0.0928], 12)

  MapApp.on "start", ->
    controller: API
    API.showMap()
