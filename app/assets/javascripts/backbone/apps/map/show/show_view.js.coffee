@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"

    ui: {
      map: "#map"
    }
    # onRender: ->
    onShow: ->
      # console.log(@ui.map)
      # console.log($("#map"))
      this.map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: false,
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

      # App.reqres.request "place:entities", places ->
      #   console.log places
