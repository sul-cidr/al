@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->


  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"

    initialize: ->
      @filters = {}
      @filteredFeatures = []
      # console.log 'filteredFeatures: ', @filteredFeatures

    setFilter: (key, evaluator) ->
      @filters[key] = evaluator
      @filterAllLayers()

    removeFilter: (key) ->
      delete @filters[key]
      @filterAllLayers()

    clearFilters: ->
      @filters = {}
      @filterAllLayers()

    filterAllLayers: ->
      @filteredFeatures = []
      _.each @features, (f) =>
        @filterLayer(f)
      # console.log @filteredFeatures
      # @filteredFeatures.addTo(@map)

      # zoom to extent

    filterLayer: (layer) ->
      visible = true
      _.each @filters, (evaluator, key) =>
        visible = visible && evaluator(layer.model)
      if visible
        # layer.setStyle(@stylePoints(layer))
        @map.addLayer layer
        @filteredFeatures.push layer
      else
        @map.removeLayer layer


    onDomRefresh: ->
      @initMap()
      App.request "placeref:entities", (placerefs) =>
        @ingest placerefs

    initMap: ->
      # console.log 'initMap'
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

    stylePoints: (feature) ->
      if feature.get("placeref_type") == "bio"
        return mapStyles.point_bio
      else
        return mapStyles.point_work

    ingest: (placerefs) ->
      @features = []
      $.each placerefs.models, (i, pl) =>
        geom = pl.attributes.geom_wkt
        if geom.substr(0,10) == 'MULTIPOINT'
          feature = L.circleMarker(swap(wellknown(geom).coordinates[0]), @stylePoints(pl) )
          feature.bindPopup(pl.get("prefname"))
          feature.model = pl
          @features.push feature

        else if geom.substr(0,15) == 'MULTILINESTRING'
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.street,
            onEachFeature: (feature, layer) ->
              layer.bindPopup pl.get("prefname")
          })
          feature.model = pl
          @features.push feature
        # TODO: visible only on hover in text
        else if geom.substr(0,12) == 'MULTIPOLYGON'
          feature = new L.GeoJSON(wellknown(geom), {
              style: mapStyles.area
              clickable: false
              # ,onEachFeature: (feature, layer) ->
              #   layer.bindPopup pl.get("prefname")
            })
          feature.model = pl
          # feature.bindPopoup(pl.get("prefname"))
          @features.push feature

      @group = L.featureGroup(@features)
      @group.addTo(@map)
      # @map.fitBounds(@group)
      window.map = @map
      window.group = @group
      window.features = @features
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
