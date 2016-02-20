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

    closePassage: ->
      $(App.placePassagesRegion.$el).addClass("hidden")
      # App.placePassagesRegion.$el.hide()

    initialize: ->
      @filters = {}
      @filteredFeatures = []
      @keyPlaces = {}
      @numPlaces = 0
      @legendColors = [0,1,2]
      window.colors = @legendColors
      @filteredAuthors = []
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

    # pre-initMap
    onDomRefresh: ->
      @initMap()

      App.request "area:entities", (areas) =>
        # console.log areas

        @ingestAreas areas
        # make available to places_app
        App.reqres.setHandler "areas:active", ->
          return areas

      @renderPlaces({clear:true})

    initMap: ->
      # console.log 'initMap'
      @map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: true,
        maxZoom: 18,
        inertiaMaxSpeed: 1000
      }).setActiveArea('viewport-authors')

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

      @London = [51.5094, -0.1212]
      # @London = [51.5120, -0.0928]

      # use if not mapbox
      # @map.addLayer(l_osm);

      # @map.addLayer(l_mblight);

      @map.setView(@London, 12)

      @map.addEventListener 'popupclose', ( (e) =>
        e.preventDefault
        $("#place_passages_region").addClass('hidden')
        # activeMarker.setIcon(houseMarker)
        return
      ), this

    $idToFeature = {areas:{}, places:{}, images:{}}
    window.idToFeature = $idToFeature

    removePlaces: (params) ->
      # window.colors = @legendColors
      places = @keyPlaces[params['key']]
      # drop marker set from map
      map.removeLayer(places.markers)

      # add color back to available array
      @legendColors.push(places.color)
      console.log 'legendColors after restore', @legendColors

      # remove legend <li>
      $("#leg_"+params['author_id']).remove()
      # delete from hash
      delete @keyPlaces[params['key']]
      # if no authors are checked any more, render all
      if params['count'] == 0
        $("#legend_compare").addClass('hidden')
        $("#legend_base").removeClass('hidden')
        # are we in a filtered state?
        # if so, restore filter
        if $("#selected_cat_authors").html() == ""
          @renderPlaces({clear:true})
        else
          console.clear()
          console.log 'need to restore filter for', @filteredAuthors
          @renderPlaces({clear:true, author_id:@filteredAuthors})

    clearKeyPlaces: ->
      # called by map:reset --> resetMap()
      @keyPlaces = {}
      @legendColors = [0,1,2]

    getColors: (prtype, legend=false, mincolor)->
      # console.log prtype, legend, mincolor
      markerColors = {
        0: {0:"yellow",1:"orange",2:"red"},
        1: {0:"cyan",1:"deepskyblue",2:"blue"}
        2: {0:"#e5f5f9",1:"#99d8c9",2:"#2ca25f"} # greens
      }

      if prtype == 'work'
        return markerColors[mincolor][2]
      else if prtype == 'bio'
        return markerColors[mincolor][0]
      else
        return markerColors[mincolor][1]

    # return tag for symbolizing places by placeref_type distrib
    prType: (count, biocount)->
      # console.log 'count, biocount', count, biocount
      if biocount == null
        return 'work'
      else if count == biocount
        return 'bio'
      else
        return 'both'

    # CHECK: not in use
    # window.imgMarker = L.MakiMarkers.icon({
    # 	icon: 'camera',
    # 	color: '#BA55D3',
    # 	size: 's'
    # });
    # mapImages: (params) ->
    #   console.log 'renderImages', params
    #   # if @imagefeatures.length() > 0
    #   #   @images.clearLayers()
    #   if typeof @images != "undefined"
    #     @images.clearLayers()
    #   @imgfeatures = []
    #   App.request "image:entities", params, (images) =>
    #     $.each images.models, (i, img) =>
    #       attribs = img.attributes
    #       geom = attribs.geom_wkt
    #       id = attribs.image_id
    #       coords = swap(wellknown(geom).coordinates)
    #       l_geom = new L.LatLng(coords[0],coords[1])
    #       feature = new L.Marker(l_geom,{
    #           icon: imgMarker
    #         })
    #       $idToFeature.images[id] = feature
    #       @imgfeatures.push(feature)
    #     console.log @imgfeatures
    #     @key = 'auth_'+params['author_id']
    #     @images = L.featureGroup(@imgfeatures)
    #     window.images = @images
    #     @keyPlaces[@key]['images'] = @images
    #     @images.addTo(@map)

    buildPopup: (params) ->
      # console.log 'buildPopup() params', params
      html = ''

      App.request "placeref:entities", params, (placerefs) =>
        _.each placerefs.models, (pr) =>
          # console.log 'placeref attributes', pr.attributes
          if pr.attributes.placeref.placeref_type == 'work'
            html += '<b>'+pr.attributes.placeref.placeref +
              '</b>, in <em>' +
              pr.attributes.work.title + '</em><br/>('+
              pr.attributes.author.prefname +
              '; '+pr.attributes.work.work_year+')&nbsp;[<span class="passage-link" val='+
              pr.attributes.placeref.passage_id+'>passage</span>]<hr/>'
          else
            html += '&#8220;'+pr.attributes.placeref.placeref +
              ',&#8221; a place in the life of ' +
              pr.attributes.author.prefname+'<hr/>'

        idToFeature.places[params['place_id']].bindPopup(html)
        # idToFeature.places[params['place_id']]._popup.setContent(html)
        idToFeature.places[params['place_id']].openPopup()
        # e.target._popup.setContent(html)

    renderPlaces: (params) ->
      # console.log 'renderPlaces', params
      # @filter = params
      # window.p = params
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
        # console.log @numPlaces + ' place models rendered' # e.g.', places.models[0]
        @features = []
        max = Math.max.apply(Math, places.map((o) ->
          o.attributes.count ))
        @mincolor = Math.min.apply(Math, @legendColors)
        # console.log 'color set from @mincolor was', @mincolor
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
              fillColor: @getColors(prtype,false,@mincolor),
              radius: scaleMarker(prcount,[1,max]),
              fillOpacity: 0.5,
              weight: 1
            })

            feature.on('click', (e) ->
              html = ''
              @filter = params
              # add this placeid
              @filter['place_id'] = pid
              # add author or work as appropriate
              if params['author_id']
                @filter['author_id'] = params['author_id']
              else if params['work_id']
                @filter['work_id'] = params['work_id']
              # console.log '@filter (params +)', @filter
              App.MapApp.Show.Controller.buildPopup @filter
              # App.request "placeref:entities", @filter, (placerefs) =>
              #   _.each placerefs.models, (pr) =>
              #     if pr.attributes.placeref.placeref_type == 'work'
              #       html += '<b>'+pr.attributes.placeref.placeref +
              #         '</b>, in <em>' +
              #         pr.attributes.work.title + '</em><br/>('+
              #         pr.attributes.author.prefname +
              #         '; '+pr.attributes.work.work_year+')&nbsp;[<span class="passage-link" val='+
              #         pr.attributes.placeref.passage_id+'>passage</span>]<hr/>'
              #     else
              #       html += '&#8220;'+pr.attributes.placeref.placeref +
              #         ',&#8221; a place in the life of ' +
              #         pr.attributes.author.prefname+'<hr/>'
              #
              #   e.target._popup.setContent(html)
            )
            # trying to replace this
            @popup = feature.bindPopup(
              pname, {
                'className': 'place-popup',
                'maxHeight': '450'}
              ).on('popupclose', (e) ->
              if $("#imagelist").length > 0
                $("#imagelist .image img").removeClass('photo-pop');
                # $("#image_modal").dialog("close");
                )

            # add model, id to feature
            feature.model = pl
            feature.options.id = pid
            # feature._leaflet_id = pid
            $idToFeature.places[pid] = feature
            @features.push feature

          else if geom.substr(0,10) == 'LINESTRING'
            feature =  new L.GeoJSON(wellknown(geom), {
              style: mapStyles.street
            })

            feature.on('click', (e) ->
              html = ''
              @filter = params
              # add this placeid
              @filter['place_id'] = pid
              # add author or work as appropriate
              if params['author_id']
                @filter['author_id'] = params['author_id']
              else if params['work_id']
                @filter['work_id'] = params['work_id']
              # console.log '@filter (params +)', @filter
              App.MapApp.Show.Controller.buildPopup @filter
              # html = ''
              # @filter = {place_id:pid}
              # if typeof params != "undefined"
              #   @filter['author_id'] = params['author_id']
              # App.request "placeref:entities", @filter, (placerefs) =>
              #   # console.log placerefs
              #   _.each placerefs.models, (pr) =>
              #     # console.log 'placeref attributes', pr.attributes
              #     if pr.attributes.placeref.placeref_type == 'work'
              #       html += '&#8220;'+pr.attributes.placeref.placeref +
              #         ',&#8221; in <em>' +
              #         pr.attributes.work.title + '</em><br/>('+
              #         pr.attributes.author.prefname +
              #         '; '+pr.attributes.work.work_year+')&nbsp;[<span class="passage-link" val='+
              #         pr.attributes.placeref.passage_id+'>passage</span>]<hr/>'
              #     else
              #       html += '&#8220;'+pr.attributes.placeref.placeref +
              #         ',&#8221; a place in the life of ' +
              #         pr.attributes.author.prefname+'<hr/>'
              #     e.target.bindPopup html
            )

            @popup = feature.bindPopup(
              pname, {
                'className': 'place-popup',
                'maxHeight': '450'}
            )
            # add model, id to feature
            feature.model = pl
            feature.options.id = pid
            # feature._leaflet_id = pid
            $idToFeature.places[pid] = feature
            @features.push feature

        @places = L.featureGroup(@features)

        # if there's an author_id, add this set to hash
        # if not, we're rendering all
        if params['author_id']
          if !($.isArray(params['author_id']))
            @key = if params['key'] then params['key'] else 'auth_'+params['author_id']
            # console.log 'key', @key
            @keyPlaces[@key] = {}
            @keyPlaces[@key]['markers'] = @places
            @keyPlaces[@key]['color'] = Math.min.apply(Math,@legendColors);
            # @keyPlaces[params['key']]['color'] = (Object.keys(@keyPlaces).length)-1
            # console.log '@keyPlaces', @keyPlaces
            window.keyplaces = @keyPlaces
            # remove this color set from available
            idx=@legendColors.indexOf(@keyPlaces[@key].color)
            @legendColors.splice(idx,1)
            # console.log '@legendColors now', @legendColors
          else
            # this is a filtered array of authors
            _.each params['author_id'], (a) =>
              if @filteredAuthors.indexOf(a) < 0
                @filteredAuthors.push a
            # console.log '@filteredAuthors', @filteredAuthors

        # populate legend
        if Object.keys(@keyPlaces).length > 0
          if $("#leg_"+params['author_id']).length == 0
            @makeLegend(params['author_id'], @mincolor)

        # TODO: stop using hardcoded total
        if @numPlaces < 770
          @map.fitBounds(@places.getBounds())
        else
          @map.setView(@London, 12)

        @places.addTo(@map)
        # @mapImages(params)
        # TODO: stop exposing these
        window.places = @places
        window.features = @features

    makeLegend: (authid, mincolor)->
      # console.log 'triggered makeLegend(), keyplaces: '+ authid, keyplaces
      $("#legend_list").append('<li id=leg_'+authid+'>'+
        '<i class="fa fa-circle fa-lg" style="color:'+@getColors('work',true,mincolor)+';"/>'+
        '<i class="fa fa-circle fa-lg" style="color:'+@getColors('bio',true,mincolor)+';"/>' +
        '<i class="fa fa-circle fa-lg" style="color:'+@getColors('both',true,mincolor)+';"/> ' +
         @authlabel+'</li>'
      )
      $("#legend_base").addClass('hidden')
      $("#legend_compare").removeClass('hidden')

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

    # onclick placeref in text
    # called by Show.Controller on trigger 'placeref:click'
    clickPlaceref: (params) ->
      console.log 'clickPlaceref params', params
      $("#imagelist .image img[prid="+params['id']+"]").addClass('photo-pop')
      App.request "placeref:entities", params, (placerefs) =>
        if placerefs.models.length == 0
          $(".ui-dialog-titlebar").prepend('<p>(not georeferenced yet)</p>')
        else
          @placeid = placerefs.models[0].attributes.placeref.place_id
          @marker = $idToFeature.places[@placeid]
          # zoom to it
          window.m = @marker
          if @marker._latlng != undefined
            # it's a point
            latlng = @marker._popup._source._latlng
          else
            # it's a linestring, zoom to its centroid
            latlng = @marker.getBounds().getCenter()
          map.setView(latlng,15,{animate:true})
          App.MapApp.Show.Controller.buildPopup({
            'place_id': @placeid
            'author_id': params['author_id']
          })

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

    l_indicator = L.mapbox.tileLayer(
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
