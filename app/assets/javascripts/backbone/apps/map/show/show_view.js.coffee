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
      @idToFeature = {}
      @features = []
      $.each placerefs.models, (i, pl) =>
        geom = pl.attributes.geom_wkt
        prid = pl.get("placeref_id")
        if geom.substr(0,10) == 'MULTIPOINT'
          feature = L.circleMarker(
            swap(wellknown(geom).coordinates[0]),
            @stylePoints(pl) )
          feature.bindPopup(pl.get("prefname"))
          # CHECK: why bother adding an id here?
          feature.options.id = prid
          # @idToFeature[prid] = feature
          @features.push feature
        else if geom.substr(0,15) == 'MULTILINESTRING'
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.street,
            # options: {"model":pl,"id":prid}
            onEachFeature: (feature, layer) ->
              layer.bindPopup pl.get("prefname")
          })
          # feature.options.model = pl
          # feature.id = prid
          # @idToFeature[prid] = feature
          @features.push feature
        # TODO: visible only on hover in text
        else if geom.substr(0,12) == 'MULTIPOLYGON'
          feature = new L.GeoJSON(wellknown(geom), {
              style: mapStyles.area
              clickable: false
              # ,onEachFeature: (feature, layer) ->
              #   layer.bindPopup pl.get("prefname")
            })
          # feature.model = pl
          # feature.options.id = prid
          # this.idToFeature[prid] = feature
          @features.push feature


      # console.log @idToFeature

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

    # triggered from passages
    highlightFeature: (id) ->
      marker = this.idToFeature[id];
      marker.setStyle(styles.feature.highlight);

    unhighlightFeature: (id) ->
      marker = this.idToFeature[id];
      marker.setStyle(styles.feature.default);

    selectFeature: (id) ->
      marker = this.idToFeature[id];
      this.map.flyTo(marker.getLatLng(), styles.zoom.feature);

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
