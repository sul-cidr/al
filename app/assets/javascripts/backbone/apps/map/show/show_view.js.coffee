@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"
    events: {
      "click .passage-link": "showOnePassage"
    }

    showOnePassage: (e) ->
      # console.log 'popup passage', $(e.currentTarget).context.attributes.val.value
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
      # console.log visible
      if visible
        # used to get bounds
        @filteredFeatures.push layer
        @markerClusters.addLayer layer
      else
        @markerClusters.removeLayer layer
        # @map.removeLayer layer

    filterAllLayers: ->
      # console.log @features
      _.each @features, (f) =>
        # console.log f
        @filterLayer(f)

      # TODO: filteredFeatures is empty sometimes !?!?!?
      # filteredFeatures[]
      window.markerClusters = @markerClusters
      window.filteredFeatures = @filteredFeatures
      # console.log @filteredFeatures
      window.filteredBounds = L.featureGroup(@filteredFeatures).getBounds()
      # markerClusters bounds are always all placerefs
      # map.fitBounds(@markerClusters.getBounds())

      # if filteredFeatures.length > 600
      map.fitBounds(filteredBounds)
      # else
      #   map.setView([51.5120, -0.0928], 12)

      # @filteredFeatures array used in PlacesApp to render summary
      App.vent.trigger('placerefs:filtered', @filteredFeatures);

    removeFilter: (key) ->
      delete @filters[key]
      @filterAllLayers()

    clearFilters: ->
      @filters = {}
      @filterAllLayers()

    swapBase: (id) ->
      # London = [51.5120, -0.0928]
      # TODO "eval is evil"
      # what is active lyr id?
      active = $("#map_chooser li.active").attr("val")
      console.log 'swapBase(id): active, new: '+ active, id
      # clear all tabs of active class
      $("#map_chooser li").removeClass('active')
      # make selected active
      $("#map_chooser li[val='"+id+"']").addClass('active')
      lyr = eval(id)
      console.log 'eval(id):', lyr
      # if the active map was historic, remove it
      if active != 'l_osm'
        console.log 'active was != l_osm, it was ', active
        map.removeLayer(eval(active))
      if id == 'l_indicator'
        if map.getZoom() < 13
          map.setView(@London, 13)
        map.addLayer(lyr)
      if id == 'l_bowles'
        if map.getZoom() < 14
          map.setView(@London, 14)
        map.addLayer(lyr)
      if id == 'l_taylor'
        if map.getZoom() < 15
          map.setView(@London, 15)
        map.addLayer(lyr)

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


    L.mapbox.accessToken = 'pk.eyJ1IjoiZWxpamFobWVla3MiLCJhIjoiY2loanVmcGljMG50ZXY1a2xqdGV3YjRkZyJ9.tZqY_fRD2pQ1a0E599nKqg'

    # OSM base layer
    l_osm = L.tileLayer(
      'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
      { detectRetina: true }
    );
    window.l_indicator = L.mapbox.tileLayer(
        'elijahmeeks.gqd89536',
      # 'https://api.mapbox.com/v4/elijahmeeks.gqd89536/{z}/{x}/{y}.png?access_token=' +
        L.mapbox.accessToken, {
        attribution: 'Indicator (1880)',
        detectRetina: true
        });
    l_bowles = L.mapbox.tileLayer(
        'elijahmeeks.36cac3di',
      # 'https://api.mapbox.com/v4/elijahmeeks.36cac3di/{z}/{x}/{y}.png?access_token=' +
        L.mapbox.accessToken, {
        attribution: 'Bowles (1783)',
        detectRetina: true
        });
    l_taylor = L.mapbox.tileLayer(
      # 'https://api.mapbox.com/v4/elijahmeeks.7dd6ynaj/{z}/{x}/{y}.png?access_token=' +
        'elijahmeeks.7dd6ynaj',
        L.mapbox.accessToken, {
        attribution: 'Taylor (1723)',
        detectRetina: true
        });

    initMap: ->
      # console.log 'initMap'
      # this.map = L.mapbox.map('map', {
      @map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: true,
        maxZoom: 18,
        inertiaMaxSpeed: 1000
      }).setActiveArea('viewport-authors');

      # var map = new L.Map(document.createElement('div')).setActiveArea('activeArea');

      baseMaps = {
        "Modern": l_osm
      }
      overlayMaps = {
        "Indicator (1880)":l_indicator
        "Bowles (1783)":l_bowles,
        "Taylor (1723)":l_taylor
        # "Satellite": l_sat
      }

      # L.control.layers(baseMaps,overlayMaps).addTo(@map);

      # Zoom buttons on top right.
      zoomControl = L.control.zoom({
        position: 'topright'
      });

      @map.addControl(zoomControl);

      @London = [51.5120, -0.0928]

      @map.addLayer(l_osm);
      # places open, authors open viewports
      @map.setView(@London, 12)

      @map.addEventListener 'popupclose', ( (e) =>
        e.preventDefault
        $("#place_passages_region").addClass('hidden')
        # activeMarker.setIcon(houseMarker)
        return
      ), this

    stylePoints: (feature) ->
      # console.log feature
      if feature.get("placeref_type") == "bio"
        return mapStyles.point_bio.start
      else if feature.get("placeref_type") == "work"
        return mapStyles.point_work.start
      # else if feature.get("area_type") == "hood"
      #   return mapStyles.point_hood

    window.bookMarker = L.MakiMarkers.icon({
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
          @popup = feature.bindPopup(
            if pl.get('placeref_type') == 'bio'
            then '<b>'+pl.get("placeref")+'</b>, a place in<br/>'+
              authhash[pl.get("author_id")]+'\'s life<br/>'+
              pl.get("placeref_id")+', '+pl.get("passage_id")
            else '<b>'+pl.get("placeref") + '</b>, in<br/>'+
              '<em>'+workhash[pl.get("work_id")].title + '</em><br/>' +
              pl.get("placeref_id") + '<br/>' +
              '<span class="passage-link" val='+pl.get("passage_id")+
                '>show passage</span>'
          )
          # popup.on("popupclose"): ->
          #   $(".passages-places").addClass('hidden')

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
      @areaFeatures = []
      $.each areas.models, (i, a) =>
        geom = a.attributes.geom_poly_wkt
        aid = a.get("id")
        if a.get("area_type") == "hood"
          # console.log geom
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.area.start
          })
          feature.model = a
          # feature.id = aid
          $idToFeature.areas[aid] = feature
          # @idToFeature[aid] = feature
          @areaFeatures.push feature

      @areas = L.featureGroup(@areaFeatures)

      @areas.addTo(@map)
      # @map.fitBounds(@group)
      window.map = @map
      window.leaf_areas = @areas
      window.areaFeatures = @features

    # triggered from passages lists, area list
    clickPlaceref: (what, id) ->
      if what == "placeref"
        marker = $idToFeature.placerefs[id];
        # console.log 'what, id, marker: '+ what, id, marker
        marker.openPopup()
        # zoom to it
        map.setView(marker._popup._source._latlng,17,{animate:true})

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
        window.activeMarker = marker

    unhighlightFeature: (what, id) ->
      marker = $idToFeature.placerefs[id];
      # console.log 'what, id, marker: '+ what, id, marker
      if what == "placeref"
        marker.setIcon(houseMarker)
        # TODO: maybe put in back in a cluster?

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
