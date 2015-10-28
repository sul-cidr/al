@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"

    initialize: ->
      @filters = {}
      @filteredFeatures = []
      # console.log 'filteredFeatures: ', @filteredFeatures

    setFilter: (key, evaluator) ->
      # console.log 'setFilter --> filterAllLayers'
      @filters[key] = evaluator
      # console.log 'setFilter:', @filters
      @filterAllLayers()

    filterLayer: (layer) ->
      visible = true
      _.each @filters, (evaluator, key) =>
        visible = visible && evaluator(layer.model)
      if visible
        @map.addLayer layer
        # console.log 'filterLayer', layer
        @filteredFeatures.push layer
      else
        @map.removeLayer layer

    filterAllLayers: ->
      # console.log '@features in filterAllLayers', @features
      @filteredFeatures = []
      @latlon = []
      _.each @features, (f) =>
        # console.log f
        @filterLayer(f)

      # TODO: this isn't an array sometimes??
      #
      window.filteredFeatures = @filteredFeatures
      window.filteredBounds = L.featureGroup(@filteredFeatures).getBounds()
      map.fitBounds(filteredBounds)
      # TODO:
      # console.log 'center, in filter', filteredBounds.getCenter()
      # @zoomToCluster 'cluster', @filteredFeatures

      App.vent.trigger('placerefs:filtered', @filteredFeatures);

    removeFilter: (key) ->
      delete @filters[key]
      @filterAllLayers()

    clearFilters: ->
      @filters = {}
      @filterAllLayers()

    zoomToCluster: (what, geom) ->
      console.log 'in zoomToCluster'

    zoomTo: (what, geom) ->
      # TODO: differentiate between hood (point) and borough (polygon)
      if what == "area"
        console.log 'zoomTo geom:', geom
        marker = $idToFeature.areas[geom.get("id")];
        mbounds = marker.getBounds()
        map.fitBounds(mbounds)

      # else if what == "hood"
      #   # area is a lonlat pair here
      #   map.setView(geom, 14)

      # else if what = "cluster"

        # cBounds = L.featureGroup(geom).getBounds()
        # console.log 'center, in zoomTo', cBounds.getCenter()
        # map.fitBounds(cBounds)

    onDomRefresh: ->
      @initMap()

      App.request "area:entities", (areas) =>
        # type: [borough (polygon) | hood (point)]
        @ingestAreas areas

      App.request "placeref:entities", (placerefs) =>
        # points, lines, polygons; type: [bioblace | worksplace]
        @ingestPlacerefs placerefs

    initMap: ->
      # console.log 'initMap'
      this.map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: false
      }).setActiveArea('viewport-authors');

      # var map = new L.Map(document.createElement('div')).setActiveArea('activeArea');

      # Zoom buttons on top right.
      zoomControl = L.control.zoom({
        position: 'topright'
      });

      this.map.addControl(zoomControl);

      # OSM base layer.
      osmLayer = L.tileLayer(
        'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
        { detectRetina: true }
      );

      London = [51.5120, -0.0928]
      # London = [51.5120, -0.1728]

      # this.map.addLayer(osmLayer);
      # places open, authors open viewports
      this.map.setView(London, 12);

    stylePoints: (feature) ->
      # console.log feature
      if feature.get("placeref_type") == "bio"
        return mapStyles.point_bio
      else if feature.get("placeref_type") == "work"
        return mapStyles.point_work
      # else if feature.get("area_type") == "hood"
      #   return mapStyles.point_hood

    # CHECK: ingestAreas and ingestPlacerefs both need to populate this
    $idToFeature = {areas:{}, placerefs:{}}
    window.idMapper = $idToFeature

    ingestAreas: (areas) ->
      console.log 'ingestAreas', areas
      # @idToFeature = {}
      @features = []
      $.each areas.models, (i, a) =>
        geom = a.attributes.geom_poly_wkt
        aid = a.get("id")
        # if a.get("area_type") == "hood"
        #   feature = L.circleMarker(
        #     # not MULTIPOINT, but POINT
        #     swap(wellknown(geom).coordinates), @stylePoints(a) )
        #   feature.model = a
        #   # feature.options.id = aid
        #   $idToFeature.areas[aid] = feature
        #   # @idToFeature[aid] = feature
        #   @features.push feature
        if a.get("area_type") == "hood"
          # console.log geom
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.area.start
          })
          feature.model = a
          # feature.id = aid
          $idToFeature.areas[aid] = feature
          # @idToFeature[aid] = feature
          @features.push feature

      # console.log $idToFeature.areas

      @areas = L.featureGroup(@features)

      @areas.addTo(@map)
      # @map.fitBounds(@group)
      window.map = @map
      window.leaf_areas = @areas
      window.areaFeatures = @features

    ingestPlacerefs: (placerefs) ->
      @features = []
      $.each placerefs.models, (i, pl) =>
        geom = pl.attributes.geom_wkt
        prid = pl.get("placeref_id")
        if geom.substr(0,5) == 'POINT'
          # console.log geom
          feature = L.circleMarker(
            swap(wellknown(geom).coordinates),
            # swap(wellknown(geom).coordinates[0]),
            @stylePoints(pl) )
          feature.model = pl
          feature.bindPopup(
            if pl.get('placeref_type') == 'bio'
            then authhash[pl.get("author_id")]+' resided at ' + pl.get('prefname')
            else '"'+pl.get('prefname') + '", in <em>' + workhash[pl.get('work_id')].title
          )
          # CHECK: why bother adding an id here?
          feature.options.id = prid
          $idToFeature.placerefs[prid] = feature
          @features.push feature

        else if geom.substr(0,15) == 'MULTILINESTRING'
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.street,
            # options: {"model":pl,"id":prid}
            onEachFeature: (feature, layer) ->
              layer.bindPopup pl.get("prefname")
          })
          feature.model = pl
          $idToFeature.placerefs[prid] = feature
          # CHECK: lines in @features defeats spatial query
          # @features.push feature

        # TODO: visible only on hover in text
        else if geom.substr(0,12) == 'MULTIPOLYGON'
          feature = new L.GeoJSON(wellknown(geom), {
              style: mapStyles.area_placeref
              clickable: false
              # ,onEachFeature: (feature, layer) ->
              #   layer.bindPopup pl.get("prefname")
            })
          feature.model = pl
          # feature.options.id = prid
          $idToFeature.placerefs[prid] = feature
          # this.idToFeature[prid] = feature
          # @features.push feature


      @placerefs = L.featureGroup(@features)

      # Highlight.
      @placerefs.on(
        'mouseover',
        this.onHighlightFeature.bind(this)
      );

      # // Unhighlight.
      @placerefs.on(
        'mouseout',
        this.onUnhighlightFeature.bind(this)
      );

      # // Select.
      @placerefs.on(
        'click',
        this.onSelectFeature.bind(this)
      );

      @placerefs.addTo(@map)
      # @map.fitBounds(@group)
      window.map = @map
      window.placerefs = @placerefs
      window.features = @features

    # TODO: better highlight/unhighlight system
    # triggered from map
    onHighlightFeature: (e) ->
      App.vent.trigger('highlight', e.layer.options.id);
      e.layer.setStyle({"weight":4, "color": "#ff8c00", "radius": 8})
      # console.log e.layer.options
      # e.layer.openPopup()

    onUnhighlightFeature: (e) ->
      App.vent.trigger('unhighlight', e.layer.options.id);
      e.layer.setStyle mapStyles.point_bio
      # e.layer.closePopup()

    onSelectFeature: (e) ->
      App.vent.trigger('select', e.layer.options.id);
      e.layer.openPopup()

    # triggered from passages, area list
    highlightFeature: (what, id) ->
      # console.log 'highlightFeature', id
      if what == "placeref"
        marker = $idToFeature.placerefs[id];
        marker.setStyle(mapStyles.features.highlight);
      else if what == "area"
        marker = $idToFeature.areas[id];
        marker.setStyle(mapStyles.area.highlight);

    unhighlightAll: ->
      # console.log 'unhighlightAll()', @areas
      @areas.setStyle(mapStyles.area.start)


    unhighlightFeature: (what, id) ->
      if what == "placeref"
        marker = $idToFeature.placerefs[id];
        marker.setStyle(mapStyles.features.point);
      else if what == "area"
        marker = $idToFeature.areas[id];
        marker.setStyle(mapStyles.area.start);

    selectFeature: (what, id) ->
      marker = $idToFeature.placerefs[id];
      this.map.flyTo(marker.getLatLng(), styles.zoom.feature);
