@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"
    events: {
      "click .passage-link": "showOnePassage"
      "click body": "closeAbout"
    }
    closeAbout: ->
      HeaderApp.Show.Controller.loadAbout()

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
      # re-initialize filters each time
      @filters = {}
      @filters[key] = evaluator
      @filterAllLayers()
      App.reqres.setHandler "filters:active", ->
        return @filters

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

    filterAllLayers: (keepzoom)->
      # reset filteredFeatures array
      @filteredFeatures = []
      setTimer('filterAllLayers')
      # console.log @features
      _.each @features, (f) =>
        # console.log f
        @filterLayer(f)

      console.timeEnd "filterAllLayers"

      # TODO: filteredFeatures is empty sometimes !?!?!?
      # filteredFeatures[]
      window.markerClusters = @markerClusters
      window.filteredFeatures = @filteredFeatures
      # console.log @filteredFeatures
      window.filteredBounds = L.featureGroup(@filteredFeatures).getBounds()

      if keepzoom == ''
        map.fitBounds(filteredBounds)
      else if keepzoom == 'london'
        map.setView([51.5120, -0.0928],12)

      # @filteredFeatures array used in PlacesApp to render summary
      App.vent.trigger('placerefs:filtered', @filteredFeatures);

    removeFilter: (key) ->
      delete @filters[key]
      @filterAllLayers()

    clearFilters: (keepzoom)->
      @filters = {}
      @filterAllLayers(keepzoom)

    swapBase: (id) ->
      # London = [51.5120, -0.0928]
      # TODO "eval is evil"
      # what is active lyr id?
      active = $("#map_chooser li.active").attr("val")
      # console.log 'swapBase(id): active, new: '+ active, id
      # clear all tabs of active class
      $("#map_chooser li").removeClass('active')
      # make selected active
      $("#map_chooser li[val='"+id+"']").addClass('active')
      lyr = eval(id)
      # console.log 'eval(id):', lyr
      # if the active map was historic, remove it
      if active != 'l_osm'
        # console.log 'active was != l_osm, it was ', active
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
      # console.log 'in zoomToCluster'

    zoomTo: (what, geom) ->
      if what == "area"
        # geom is an area model; zoom to its voronoi extents
        # console.log 'zoomTo geom:', geom
        marker = $idToFeature.areas[geom.get("area_id")];
        mbounds = marker.getBounds()
        map.fitBounds(mbounds)
      window.mbounds = mbounds
      # get the bounds of the resulting viewport
      window.vbounds = turf.polygon([createPolygonFromBounds( map.getBounds() )])

    onDomRefresh: ->
      @initMap()

      App.request "area:entities", (areas) =>
        # add to map
        # allAreas = areas # clone collection
        @ingestAreas areas
        # make available to places_app
        App.reqres.setHandler "areas:active", ->
          return areas
          # return areas
        # AL.PlacesApp.List.Controller.startPlaces()

      App.request "placeref:entities", (placerefs) =>
        # points, lines, polygons; type: [bioblace | worksplace]
        @ingestPlacerefs placerefs

      # $("#spin_authors").addClass('hidden')


    L.mapbox.accessToken = 'pk.eyJ1IjoiZWxpamFobWVla3MiLCJhIjoiY2loanVmcGljMG50ZXY1a2xqdGV3YjRkZyJ9.tZqY_fRD2pQ1a0E599nKqg'

    # mapbox light base in progress
    l_mblight = L.mapbox.tileLayer(
        # 'elijahmeeks.8a9e3cb1', # light
        'elijahmeeks.e72a8419',  # emerald
        L.mapbox.accessToken, {
        attribution: 'Mapbox',
        detectRetina: true
        });
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
        "Modern": l_mblight
        # "Modern": l_osm
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

      @map.addLayer(l_mblight);
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
    # $idToFeature = {areas:[], placerefs:[]}
    $idToFeature = {areas:{}, placerefs:{}}
    # $foo = {areas:[], placerefs:[]}
    window.idToFeature = $idToFeature
    # window.foo = $foo

    ingestPlacerefs: (placerefs) ->
      # console.log 'placeref models to be ingested', placerefs.models
      @features = []
      $.each placerefs.models, (i, pl) =>
        geom = pl.attributes.geom_wkt
        prid = pl.get("placeref_id")
        aid = pl.get("author_id").toString()
        workid = pl.get("work_id")

        # POINT data
        if geom.substr(0,5) == 'POINT'
          # console.log wellknown(geom).coordinates
          feature = L.marker(
            swap(wellknown(geom).coordinates))

          feature.model = pl
          @popup = feature.bindPopup(
            if pl.get('placeref_type') == 'bio'
            then '<b>'+pl.get("placeref")+'</b>, a place in<br/>'+
              authhash[pl.get("author_id")]+'\'s life<br/>'+
              pl.get("placeref_id")
            else '<b>'+pl.get("placeref") + '</b>, in<br/>'+
              '<em>'+workhash[pl.get("work_id")].title + '</em>'+'<br/>'+
              'by '+authhash[pl.get("author_id")]+'. '+
              '<span class="passage-link" val='+pl.get("passage_id")+
                '>show passage</span> ['+pl.get("placeref_id") + ']'
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
          feature.options.workid = workid
          # obj = {}
          # obj[prid]=feature
          # $idToFeature.placerefs.push obj
          # $foo.placerefs[prid]={feat:feature,wid:workid}

          $idToFeature.placerefs[prid] = feature
          @features.push feature

        # LINESTRING data
        else if geom.substr(0,10) == 'LINESTRING'
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.street
            # options: {"model":pl,"id":prid}
            onEachFeature: (feature, layer) ->
              layer.bindPopup pl.get("placeref")
          })
          # CHECK: neither of these actually do anything
          feature.model = pl
          feature.options.id = prid
          feature.options.workid = workid
          # $idToFeature.placerefs.push {prid:feature}
          $idToFeature.placerefs[prid] = feature
          # $foo.placerefs[prid]={feat:feature,wid:workid}

          # CHECK: lines in @features defeats spatial query
          @features.push feature


      @placerefs = L.featureGroup(@features)

      @markerClusters = L.markerClusterGroup(
        # {disableClusteringAtZoom: 17}
      );

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

      # click gets a popup
      @placerefs.on(
        'click',
        this.onSelectFeature.bind(this)
      );

      # clusters
      @markerClusters.addTo(@map)

      # TODO: stop exposing these
      window.map = @map
      window.placerefs = @placerefs
      window.features = @features
      window.markers = @markerClusters
      # stop spinner
      $("#spin_map").addClass('hidden')

    # neighborhood voronoi polygons
    ingestAreas: (areas) ->
      @areaFeatures = []
      $.each areas.models, (i, a) =>
        geom = a.attributes.geom_poly_wkt
        aid = a.get("area_id")
        # they're all hoods, but leaves possibility for hierarchy
        if a.get("area_type") == "hood"
          # console.log geom
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.area.start
          })

          # model-to-map feature hash
          $idToFeature.areas[aid] = feature
          @areaFeatures.push feature

      @areas = L.featureGroup(@areaFeatures)

      @areas.addTo(@map)
      # TODO: stop exposing these
      window.map = @map
      window.leaf_areas = @areas
      window.areaFeatures = @features

    # called by Show.Controller on trigger 'placeref:click'
    clickPlaceref: (prid) ->
      # TODO: if search tab active, filteredFeatures doesn't exist
      if $("#content_nav_region li.active").attr('value') != 'search'
        @marker = _.filter(filteredFeatures, (item) ->
          item.model.attributes.placeref_id == parseInt(prid) )[0]
      else
        @marker = _.filter(features, (item) ->
          item.model.attributes.placeref_id == parseInt(prid) )[0]

      # console.log 'clickPlaceref marker ', @marker
      # zoom to it
      # console.log '@marker', @marker
      window.m = @marker
      if @marker._latlng != undefined
        # console.log '!=undefined', @marker
        # it's a point
        # remove it from a cluster if it's in one
        @markerClusters.removeLayer(@marker)
        # put it back on map
        map.addLayer(@marker)
        @marker.openPopup()
        map.setView(@marker._popup._source._latlng,15,{animate:true})
      else
        # it's a linestring
        map.setView(@marker.getBounds().getCenter(),15,{animate:true})
        @marker.openPopup()

    # triggered from passages, area list
    highlightFeature: (prid) ->
      window.wid = App.reqres.getHandler('activework:id')()
      # if what == "placeref"
      marker = $idToFeature.placerefs[prid];
      # if it's a point in cluster, remove it and re-place on map:
      if marker._latlng != undefined
        # console.log 'highlightFeature marker pre ',marker
        @markerClusters.removeLayer(marker)
        map.addLayer(marker)
        # make it bigger
        marker.setIcon(houseMarkerM)
        # console.log 'highlightFeature marker ',marker
        window.activeMarker = marker
      else
        # console.log 'a linestring', marker

    unhighlightFeature: (prid) ->
      marker = $idToFeature.placerefs[prid];
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
