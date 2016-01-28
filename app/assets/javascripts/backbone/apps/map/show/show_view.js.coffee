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
      @keyPlaces = {}
      @numPlaces = 0
      # console.log 'filteredFeatures: ', @filteredFeatures

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

        @ingestAreas areas
        # make available to places_app
        App.reqres.setHandler "areas:active", ->
          return areas

      @renderPlaces()
      # @renderPlaces({clear:true})
      # @renderPlaces({author_id:null, key:null, clear:null})

    initMap: ->
      # console.log 'initMap'
      @map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: true,
        maxZoom: 18,
        inertiaMaxSpeed: 1000
      }).setActiveArea('viewport-authors');

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

      # TODO: avoid mapbox until gem is fixed
      # @map.addLayer(l_osm);
      @map.addLayer(l_mblight);

      @map.setView(@London, 12)

      @map.addEventListener 'popupclose', ( (e) =>
        e.preventDefault
        $("#place_passages_region").addClass('hidden')
        # activeMarker.setIcon(houseMarker)
        return
      ), this

    $idToFeature = {areas:{}, places:{}}
    window.idToFeature = $idToFeature

    removePlaces: (params) ->
      # drop from map
      map.removeLayer(@keyPlaces[params['key']])
      # remove from legend
      # remove element w/ id = leg_<author_id>
      $("#leg_"+params['author_id']).remove()
      # delete from hash
      delete @keyPlaces[params['key']]
      # if no authors are checked any more, render all
      if params['count'] == 0
        $("#legend").addClass('hidden')
        # console.log '@keyPlaces', @keyPlaces
        @renderPlaces({clear:true})

    getColor: (prtype, legend=false)->
      length = Object.keys(@keyPlaces).length
      len = if !legend then length else (length-1)
      markerColors = {
        0: {0:"yellow",1:"orange",2:"red"},
        1: {0:"cyan",1:"deepskyblue",2:"blue"}
        2: {0:"#e5f5f9",1:"#99d8c9",2:"#2ca25f"} # greens
      }
      if prtype == 'work'
        return markerColors[len][2]
      else if prtype == 'bio'
        return markerColors[len][0]
      else
        return markerColors[len][1]

    # what distribution of placeref_type per place?
    prType: (count, biocount)->
      # console.log 'count, biocount', count, biocount
      if biocount == null
        return 'work'
      else if count == biocount
        return 'bio'
      else
        return 'both'

    clearKeyPlaces: ->
      @keyPlaces = {}

    renderPlaces: (params) ->
      console.log 'renderPlaces', params
      window.p = params
      # console.log '@keyPlaces length:', Object.keys(@keyPlaces).length
      if typeof @places != "undefined"
        if params && params['clear'] == true
          @places.clearLayers()
          # @map.setView(@London, 12)
      if params && params['author_id'] && !($.isArray(params['author_id']))
        # console.log $.isArray(params['author_id'])
        App.request "author:entity", params['author_id'], (author) =>
          @authlabel = author.get("label")
      App.request "place:entities", params, (places) =>
        @numPlaces = places.models.length
        console.log @numPlaces + ' place models rendered' # e.g.', places.models[0]
        @features = []
        max = Math.max.apply(Math, places.map((o) ->
          o.attributes.count ))
        $.each places.models, (i, pl) =>
          # TODO: get max of count()
          attribs = pl.attributes.place
          prcount = pl.attributes.count # placerefs-per-place
          prtype = @prType(prcount, pl.attributes.biocount) # return work, bio, both
          geom = attribs.geom_wkt
          pid = attribs.place_id
          pname = attribs.prefname
          # console.log '@getColor prtype', @getColor(prtype)
          if geom.substr(0,5) == 'POINT'
            coords = swap(wellknown(geom).coordinates)
            l_geom = new L.LatLng(coords[0],coords[1])

            feature = new L.CircleMarker(l_geom, {
              color: '#000',
              fillColor: @getColor(prtype),
              radius: scaleMarker(prcount,[1,max]),
              fillOpacity: 0.5,
              weight: 1
            })

            feature.on('click', (e) ->
              html = ''
              @filter = {place_id:pid}
              if params && params['author_id']
              # if typeof params != "undefined"
                @filter['author_id'] = params['author_id']
                # console.log 'on click params: ',@filter
              else if params && params['work_id']
                @filter['work_id'] = params['work_id']
                # console.log 'on click params: ',@filter

              App.request "placeref:entities", @filter, (placerefs) =>
                # console.log 'params sent to placeref:entities', @filter
                console.log 'placerefs for popup', placerefs
                _.each placerefs.models, (pr) =>
                  # console.log 'placeref attributes', pr.attributes
                  if pr.attributes.placeref.placeref_type == 'work'
                    html += '&#8220;'+pr.attributes.placeref.placeref +
                      ',&#8221; in <em>' +
                      pr.attributes.work.title + '</em><br/>('+
                      pr.attributes.author.prefname +
                      '; '+pr.attributes.work.work_year+')&nbsp;[<span class="passage-link" val='+
                      pr.attributes.placeref.passage_id+'>passage</span>]<hr/>'
                  else
                    html += '&#8220;'+pr.attributes.placeref.placeref +
                      ',&#8221; a place in the life of ' +
                      pr.attributes.author.prefname+'<hr/>'

                e.target._popup.setContent(html)
            )
            @popup = feature.bindPopup(
              pname, {
                'className': 'place-popup',
                'maxHeight': '450'}
            )
            # add model, id to feature
            feature.model = pl
            feature.options.id = pid
            $idToFeature.places[pid] = feature
            @features.push feature

          else if geom.substr(0,10) == 'LINESTRING'
            feature =  new L.GeoJSON(wellknown(geom), {
              style: mapStyles.street
            })

            feature.on('click', (e) ->
              html = ''
              @filter = {place_id:pid}
              if typeof params != "undefined"
                @filter['author_id'] = params['author_id']
              App.request "placeref:entities", @filter, (placerefs) =>
                # console.log placerefs
                _.each placerefs.models, (pr) =>
                  # console.log 'placeref attributes', pr.attributes
                  if pr.attributes.placeref.placeref_type == 'work'
                    html += '&#8220;'+pr.attributes.placeref.placeref +
                      ',&#8221; in <em>' +
                      pr.attributes.work.title + '</em><br/>('+
                      pr.attributes.author.prefname +
                      '; '+pr.attributes.work.work_year+')&nbsp;[<span class="passage-link" val='+
                      pr.attributes.placeref.passage_id+'>passage</span>]<hr/>'
                  else
                    html += '&#8220;'+pr.attributes.placeref.placeref +
                      ',&#8221; a place in the life of ' +
                      pr.attributes.author.prefname+'<hr/>'
                  e.target.bindPopup html
            )
            @popup = feature.bindPopup(
              pname, {
                'className': 'place-popup',
                'maxHeight': '450'}
            )
            # add model, id to feature
            feature.model = pl
            feature.options.id = pid
            $idToFeature.places[pid] = feature
            @features.push feature

        @places = L.featureGroup(@features)

        # if there's an author_id, add this set to hash
        # if not, we're rendering all
        if params != undefined
          if params['author_id'] != undefined
            @keyPlaces[params['key']] = @places
            window.keyplaces = @keyPlaces
            # console.log @keyPlaces

        # populate legend
        if Object.keys(@keyPlaces).length > 0
          $("#legend_list").append('<li id=leg_'+params['author_id']+'>'+
            '<i class="fa fa-circle fa-lg" style="color:'+@getColor('work',true)+';"/>'+
            '<i class="fa fa-circle fa-lg" style="color:'+@getColor('bio',true)+';"/>' +
            '<i class="fa fa-circle fa-lg" style="color:'+@getColor('both',true)+';"/> ' +
             @authlabel+'</li>'
          )
          # $("#legend_list").append('<li>'+authLabel[params['author_id']]+'</li>')
          $("#legend").removeClass('hidden')

        # TODO: stop using hardcoded total
        if @numPlaces < 604
          @map.fitBounds(@places.getBounds())
        else
          @map.setView(@London, 12)

        @places.addTo(@map)
        # TODO: stop exposing these
        window.places = @places
        window.features = @features

    # neighborhood voronoi polygons (not visible)
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

    # buildPopup: (filter) ->
    #   html = ''
    #   @filter = {place_id:pid}
    #   if typeof params != "undefined"
    #     @filter['author_id'] = params['author_id']
    #
    #   App.request "placeref:entities", @filter, (placerefs) =>
    #     # console.log placerefs
    #     _.each placerefs.models, (pr) =>
    #       # console.log 'placeref attributes', pr.attributes
    #       if pr.attributes.placeref.placeref_type == 'work'
    #         html += '&#8220;'+pr.attributes.placeref.placeref +
    #           ',&#8221; in <em>' +
    #           pr.attributes.work.title + '</em><br/>('+
    #           pr.attributes.author.prefname +
    #           '; '+pr.attributes.work.work_year+')&nbsp;[<span class="passage-link" val='+
    #           pr.attributes.placeref.passage_id+'>passage</span>]<hr/>'
    #       else
    #         html += '&#8220;'+pr.attributes.placeref.placeref +
    #           ',&#8221; a place in the life of ' +
    #           pr.attributes.author.prefname+'<hr/>'

    # click placeref in text
    # called by Show.Controller on trigger 'placeref:click'
    clickPlaceref: (prid) ->
      # TODO: get place_id from placeref_id
      console.log 'prid', prid
      App.request "placeref:entities", {id:prid}, (placerefs) =>
        if placerefs.models.length == 0
          console.log 'placeref not georeferenced yet'
        else
          @placeid = placerefs.models[0].attributes.placeref.place_id
          console.log 'place_id of clicked placeref: ', @placeid
          @marker = $idToFeature.places[@placeid]
          # @marker = _.filter(@features, (f) ->
          #   f.model.attributes.place_id == @placeid )[0]
          console.log 'clickPlaceref() marker ', @marker
          # # zoom to it
          window.m = @marker
          if @marker._latlng != undefined
            @marker.openPopup()
            map.setView(@marker._popup._source._latlng,15,{animate:true})
          else
            # it's a linestring, zoom to its centroid
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

    # L.mapbox.accessToken = 'pk.eyJ1IjoiZWxpamFobWVla3MiLCJhIjoiY2loanVmcGljMG50ZXY1a2xqdGV3YjRkZyJ9.tZqY_fRD2pQ1a0E599nKqg'

    # mapbox light basemap, in progress
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
