@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"
    events: {
      "click .passage-link": "showOnePassage"
    }

    showOnePassage: (e) ->
      console.log 'popup passage', $(e.currentTarget).context.attributes.val.value
      id = $(e.currentTarget).context.attributes.val.value
      # TODO: load passage in right panel
      Show.Controller.showOnePassage(id)

    initialize: ->
      @filters = {}
      @filteredFeatures = []
      # console.log 'filteredFeatures: ', @filteredFeatures

    setFilter: (key, evaluator) ->
      @filters[key] = evaluator
      @filterAllLayers()

    filterLayer: (layer) ->
      visible = true
      _.each @filters, (evaluator, key) =>
        visible = visible && evaluator(layer.model)
      if visible
        # used to get bounds
        @filteredFeatures.push layer
        @markerClusters.addLayer layer
      else
        @markerClusters.removeLayer layer
        # @map.removeLayer layer

    filterAllLayers: ->
      # console.log '@features in filterAllLayers', @features
      # @filteredFeatures = []
      _.each @features, (f) =>
        # console.log f
        @filterLayer(f)

      # TODO: filteredFeatures is empty sometimes !?!?!?
      # filteredFeatures[]
      window.markerClusters = @markerClusters
      window.filteredFeatures = @filteredFeatures
      window.filteredBounds = L.featureGroup(@filteredFeatures).getBounds()
      # markerClusters bounds are always all placerefs
      # map.fitBounds(@markerClusters.getBounds())

      map.fitBounds(filteredBounds)
      # TODO:
      # console.log 'center, in filter', filteredBounds.getCenter()

      # @filteredFeatures array used in PlacesApp to render summary
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
      if what == "area"
        # geom is an area model; zoom to its voronoi extents
        console.log 'zoomTo geom:', geom
        marker = $idToFeature.areas[geom.get("id")];
        mbounds = marker.getBounds()
        map.fitBounds(mbounds)
      window.mbounds = mbounds
      # get the bounds of the resulting viewport
      window.vbounds = turf.polygon([createPolygonFromBounds( map.getBounds() )])

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
      # this.map = L.mapbox.map('map', {
      this.map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: false,
        maxZoom: 17
      }).setActiveArea('viewport-authors');

      # var map = new L.Map(document.createElement('div')).setActiveArea('activeArea');

      # Zoom buttons on top right.
      zoomControl = L.control.zoom({
        position: 'topright'
      });

      this.map.addControl(zoomControl);

      # OSM base layer
      l_osmLayer = L.tileLayer(
        'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
        { detectRetina: true }
      );

      l_sat = L.tileLayer('elijahmeeks.kd3jd7e1')
      l_indicator = L.tileLayer('elijahmeeks.gqd89536')
      l_taylor = L.tileLayer('elijahmeeks.7dd6ynaj')
      l_bowles = L.tileLayer('elijahmeeks.36cac3di')
      #
      # l_sat = L.mapbox.tileLayer('elijahmeeks.kd3jd7e1')
      # l_indicator = L.mapbox.tileLayer('elijahmeeks.gqd89536')
      # l_taylor = L.mapbox.tileLayer('elijahmeeks.7dd6ynaj')
      # l_bowles = L.mapbox.tileLayer('elijahmeeks.36cac3di')
      # mapbox://styles/elijahmeeks/cigvm9rhm000d90ksrihyve8x

      baselayers = {
        # "Styled OSM": l_mbstudio,
        "Satellite": l_sat
      }
      window.overlays = {
        "Indicator (1880)":l_indicator,
        "Bowles (1783)":l_bowles,
        "Taylor (1723)":l_taylor,
      }

      # lyrs = L.control.layers(overlays).addTo(map);

      London = [51.5120, -0.0928]

      this.map.addLayer(l_osmLayer);
      # places open, authors open viewports
      this.map.setView(London, 12)

    stylePoints: (feature) ->
      # console.log feature
      if feature.get("placeref_type") == "bio"
        return mapStyles.point_bio.start
      else if feature.get("placeref_type") == "work"
        return mapStyles.point_work.start
      # else if feature.get("area_type") == "hood"
      #   return mapStyles.point_hood

    bookMarker = L.MakiMarkers.icon({
    	icon: 'library',
    	color: '#CD5C5C',
    	size: 's'
    });

    window.houseMarker = L.MakiMarkers.icon({
    	icon: 'lodging',
    	color: '#BA55D3',
    	size: 's'
    });

    window.houseMarkerM = L.MakiMarkers.icon({
    	icon: 'lodging',
    	color: '#BA55D3',
    	size: 'm'
    });

    # CHECK: ingestAreas and ingestPlacerefs both need to populate this
    $idToFeature = {areas:{}, placerefs:{}}
    window.idMapper = $idToFeature

    ingestPlacerefs: (placerefs) ->
      # console.log placerefs.models
      @features = []
      $.each placerefs.models, (i, pl) =>
        geom = pl.attributes.geom_wkt
        prid = pl.get("placeref_id")
        aid = pl.get("author_id").toString()
        # if geom.substr(0,10) == 'MULTIPOINT'
        if geom.substr(0,5) == 'POINT'
          # console.log wellknown(geom).coordinates
          feature = L.marker(
            swap(wellknown(geom).coordinates))

          feature.model = pl
          feature.bindPopup(
            if pl.get('placeref_type') == 'bio'
            # then '"'+pl.get("author_id")+'"' + ' resided at ' +
            then pl.get("placeref")+' was on '+authhash[pl.get("author_id")]+'\'s lifepath' +
              '<br/>'+pl.get("placeref_id")
            else '"'+pl.get("placeref") + '", in <em>' +
              workhash[pl.get("work_id")].title + '<br/>' +
              pl.get("placeref_id") + '<br/>' +
              '<span class="passage-link" val='+pl.get("passage_id")+
                '>show passage</span>'
          )
          feature.setIcon(
            if pl.get('placeref_type') == 'bio'
            then houseMarker
            else bookMarker
          )
          # CHECK: why bother adding an id here?
          feature.options.id = prid
          $idToFeature.placerefs[prid] = feature
          @features.push feature

        else if geom.substr(0,10) == 'LINESTRING'
        # else if geom.substr(0,15) == 'MULTILINESTRING'
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.street
            # options: {"model":pl,"id":prid}
            onEachFeature: (feature, layer) ->
              layer.bindPopup pl.get("placeref")
          })
          # CHECK: neither of these actually do anything
          feature.model = pl
          feature.options.id = prid
          $idToFeature.placerefs[prid] = feature

          # CHECK: lines in @features defeats spatial query
          @features.push feature

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

      @markerClusters = L.markerClusterGroup();

      @markerClusters.addLayer(@placerefs);


      # Highlight.
      # @placerefs.on(
      #   'mouseover',
      #   this.onSelectFeature.bind(this)
      # );
      #
      # # Unhighlight.
      # @placerefs.on(
      #   'mouseout',
      #   this.onUnselectFeature.bind(this)
      # );

      # Select
      @placerefs.on(
        'click',
        this.onSelectFeature.bind(this)
      );

      # clusters?
      @markerClusters.addTo(@map)
      # @placerefs.addTo(@map)
      # @map.fitBounds(@group)

      # TODO: stop exposing these
      window.map = @map
      window.placerefs = @placerefs
      window.features = @features
      window.markers = @markerClusters

    ingestAreas: (areas) ->
      # console.log 'ingestAreas', areas
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

    # TODO: better highlight/unhighlight system
    # CHECK: why trigger->map_app->controller->@highlightFeature ?
    # triggered from map
    # onHighlightFeature: (e) ->
    #   console.log 'onHightlightFeature', e.layer
    #   color = e.layer.options.color
    #   id = e.layer.options.id
    #   # console.log 'e', e.layer
    #   window.active = e
    #   if e.layer.options.color == "green"
    #     e.layer.setStyle({"color":"orange", "weight":6})
    #   else if e.layer.options.color == "blue"
    #     @highlightFeature('workplace', id)
    #   else
    #     @highlightFeature('bioplace', id)
    # #
    # onUnhighlightFeature: (e) ->
    #   color = e.layer.options.color
    #   id = e.layer.options.id
    #   if color == "orange"
    #     e.layer.setStyle({"color":"green", "weight":4})
    #   else if color == "blue"
    #     @unhighlightFeature('workplace', id)
    #   else
    #     @unhighlightFeature('bioplace', id)

    # triggered from passages, area list
    clickPlaceref: (what, id) ->
      if what == "placeref"
        marker = $idToFeature.placerefs[id];
        console.log 'what, id, marker: '+ what, id, marker
        # ex. Donne 30265 Bread Street
        # if it's in a cluster, remove it and re-place on map:
        # @markerClusters.removeLayer(marker)
        # map.addLayer(marker)
        # # make it big
        # marker.setIcon(houseMarkerL)
        # zoom to it
        map.setView(marker._popup._source._latlng,17,{animate:true})

        # marker.setStyle(mapStyles.point_work.highlight);
      # if what == "workplace"
      #   marker.setStyle(mapStyles.point_work.highlight);
      else if what == "bioplace"
        marker = $idToFeature.placerefs[id];
      else if what == "area"
        marker = $idToFeature.areas[id];
        marker.setStyle(mapStyles.area.highlight);

    # triggered from passages, area list
    highlightFeature: (what, id) ->
      if what == "placeref"
        marker = $idToFeature.placerefs[id];
        # console.log 'highlightFeature: '+ what, id, marker
        # ex. Donne 30265 Bread Street

        # if it's in a cluster, remove it and re-place on map:
        @markerClusters.removeLayer(marker)
        map.addLayer(marker)
        # make it big
        marker.setIcon(houseMarkerM)

      # else if what == "bioplace"
      #   marker.setStyle(mapStyles.point_bio.highlight);
      # else if what == "area"
      #   marker = $idToFeature.areas[id];
      #   marker.setStyle(mapStyles.area.highlight);

    unhighlightFeature: (what, id) ->
      marker = $idToFeature.placerefs[id];
      # console.log 'what, id, marker: '+ what, id, marker
      if what == "placeref"
        marker.setIcon(houseMarker)
        # TODO: maybe put in back in a cluster?

      # if what == "workplace"
      #   marker.setStyle(mapStyles.point_work.start);
      # else if what == "bioplace"
      #   marker.setStyle(mapStyles.point_bio.start);
      # else if what == "area"
      #   marker = $idToFeature.areas[id];
      #   marker.setStyle(mapStyles.area.start);

    unhighlightAll: ->
      # console.log 'unhighlightAll()', @areas
      @areas.setStyle(mapStyles.area.start)

    onSelectFeature: (e) ->
      # App.vent.trigger('placeref:select', e.layer.options.id);
      e.layer.openPopup()

    onUnselectFeature: (e) ->
      # App.vent.trigger('placeref:select', e.layer.options.id);
      e.layer.closePopup()

    selectFeature: (what, id) ->
      marker = $idToFeature.placerefs[id];
      this.map.flyTo(marker.getLatLng(), styles.zoom.feature);
