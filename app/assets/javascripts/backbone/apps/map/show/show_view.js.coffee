@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"

    onDomRefresh: ->
      @initMap()
      App.request "placeref:entities", (placerefs) =>
        @ingest placerefs

    initMap: ->
      console.log 'initMap'
      this.map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: false
      });

      # Zoom buttons on top right.
      zoomControl = L.control.zoom({
        position: 'topright'
      });

      this.map.addControl(zoomControl);

      # OSM base layer.
      osmLayer = L.tileLayer(
        '//{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
        { detectRetina: true }
      );

      this.map.addLayer(osmLayer);
      # Default viewport.
      this.map.setView([51.5120, -0.1228], 12);

    ingest: (placerefs) ->
      @features = []
      # pointFeatures = []
      # lineFeatures = []
      # polygonFeatures = []
      $.each placerefs.models, (i, pl) =>
        geom = pl.attributes.geom_wkt
        # console.log geom
        if geom.substr(0,10) == 'MULTIPOINT'
          feature = L.circleMarker(swap(wellknown(geom).coordinates[0]), mapStyles.point)
          feature.model = pl
          @features.push feature
          # @features.push L.circleMarker(swap(wellknown(geom).coordinates[0]), mapStyles.point)
        else if geom.substr(0,15) == 'MULTILINESTRING'
          @features.push new L.GeoJSON(wellknown(geom), mapStyles.street)
        else if geom.substr(0,12) == 'MULTIPOLYGON'
          @features.push new L.GeoJSON(wellknown(geom), mapStyles.area)

      @group = L.layerGroup(@features)
      # markers = L.layerGroup(pointFeatures);
      # lines = L.featureGroup(lineFeatures);
      # polygons = L.layerGroup(polygonFeatures);
      @group.addTo(@map)
      # polygons.addTo(this.map)
      # lines.addTo(this.map)
      # markers.addTo(this.map)


## from graves_ui
      # this.idToPlace = {};
    #   features = 'empty right now'
    #   # Parse WKT -> GeoJSON.
    #   # features = data.map(b => {
    #   #
    #   #   # Extract the lon/lat.
    #   #   point = wellknown(b.geom).coordinates[0];
    #   #
    #   #   # Copy the SVG defaults.
    #   #   # options = _.clone(styles.place.default);
    #   #
    #   #   # Create the marker.
    #   #   feature = L.circleMarker(
    #   #     swap(point),
    #   #     _.merge(options, {id: b.id})
    #   #   );
    #   #
    #   #   # Set radius. (Default to 20 graves?)
    #   #   feature.setRadius(Math.log(b.count || 20)*3);
    #   #
    #   #   # Attach the popup.
    #   #   feature.bindPopup(b.town, {
    #   #     closeButton: false
    #   #   });
    #   #
    #   #   # Map id -> feature.
    #   #   this.idToPlace[b.id] = feature;
    #   #
    #   #   # return feature;
    #   #
    #   # });
    #
    #   # Add feature group to map.
    #   this.places = L.featureGroup(features);
    #   this.places.addTo(this.map);
    #
    #   # Highlight.
    #   this.places.on(
    #     'mouseover',
    #     this.onHighlightPlace.bind(this)
    #   );
    #
    #   # Unhighlight.
    #   this.places.on(
    #     'mouseout',
    #     this.onUnhighlightPlace.bind(this)
    #   );
    #
    #   # Select.
    #   this.places.on(
    #     'click',
    #     this.onSelectPlace.bind(this)
    #   );
    #
    # # /**
    # #  * Highlight a place.
    # #  *
    # #  * @param {Number} id
    # #  */
    # highlightPlace: (id) ->
    #   marker = this.idToPlace[id];
    #   marker.setStyle(styles.place.highlight);
    #
    # # /**
    # #  * Unhighlight a place.
    # #  *
    # #  * @param {Number} id
    # #  */
    # unhighlightPlace: (id) ->
    #   marker = this.idToPlace[id];
    #   marker.setStyle(styles.place.default);
    #
    #
    # # /**
    # #  * Focus on a place.
    # #  *
    # #  * @param {Number} id
    # #  */
    # selectPlace: (id) ->
    #   marker = this.idToPlace[id];
    #   this.map.flyTo(marker.getLatLng(), styles.zoom.place);
