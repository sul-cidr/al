@AL = do (Backbone, Marionette) ->

  App = new (Marionette.Application)

  App.on 'initialize:before', ->
    console.log 'initialize before'

  App.addInitializer ->
    # console.log 'initialize'
    App.addRegions
      headerRegion: '#header-region'
      mapRegion: '#map-region'
      authorsRegion:
        selector: '#authors-region'
        #regionClass: AuthorsRegion
      passagesRegion: '#bio-passages'
      placesRegion:
        selector: '#places-region'
        #regionClass: PlacesRegion

    App.module('HeaderApp').start()
    # App.module('AuthorsApp').start()
    # App.module('PlacesApp').start()
    # App.module('MapApp').start()

  App.on 'start', ->
    if Backbone.history
      return Backbone.history.start()

    return

  App
