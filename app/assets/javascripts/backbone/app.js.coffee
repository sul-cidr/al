@AL = do (Backbone, Marionette) ->

  globalChannel = Backbone.Wreqr.radio.channel('global');

  App = new (Marionette.Application)

  App.on 'initialize:before', ->
    # console.log 'initialize before'
    @FaderRegion = Marionette.Region.extend(attachHtml: (view) ->
      # Some effect to show the view:
      # @$el.empty().append view.el
      @$el.show().fadeIn 'slow'
      return
    )

  App.addInitializer ->
    # console.log 'App initialized'
    App.addRegions
      headerRegion: '#header-region'
      mapRegion: '#map-region'
      authorsRegion:
        selector: '#authors-region'
        #regionClass: AuthorsRegion

      authorContentRegion:
        selector: '#author_content_region'

      placesRegion:
        selector: '#places-region'
        #regionClass: PlacesRegion

      placePassagesRegion:
        selector: '#place_passages_region'
        # regionClass: @FaderRegion

    App.module('HeaderApp').start()
    App.module('AuthorsApp').start()
    App.module('PlacesApp').start()
    App.module('MapApp').start()

  # App.on 'initialize:after', ->
  App.on 'start', ->
    # console.log "App started"
    if Backbone.history
      return Backbone.history.start()
    return

  App
