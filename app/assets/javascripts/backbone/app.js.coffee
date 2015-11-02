@AL = do (Backbone, Marionette) ->

  globalChannel = Backbone.Wreqr.radio.channel('global');

  App = new (Marionette.Application)

  # from a 2012 blog post
  # https://lostechies.com/derickbailey/2012/04/17/managing-a-modal-dialog-with-backbone-and-marionette/
  ModalRegion = Backbone.Marionette.Region.extend(
    el: '#modal'
    constructor: ->
      # throws error
      # _.bindAll this
      Backbone.Marionette.Region::constructor.apply this, arguments
      @on 'view:show', @showModal, this
    getEl: (selector) ->
      $el = $(selector)
      $el.on 'hidden', @close
      $el
    showModal: (view) ->
      view.on 'close', @hideModal, this
      @$el.modal 'show'
    hideModal: ->
      @$el.modal 'hide'
  )

  App.on 'initialize:before', ->

    # CHECK: does this even work?
    @FaderRegion = Marionette.Region.extend(attachHtml: (view) ->
      # Some effect to show the view:
      # @$el.empty().append view.el
      @$el.show().fadeIn 'slow'
      return
    )

  App.addInitializer ->
    # console.log 'App initialized'
    App.addRegions
      headerRegion: '#header_region'
      mapRegion: '#map_region'
      contentRegion: '#content_region'
      authorsRegion:
        selector: '#authors_region'
        #regionClass: AuthorsRegion

      authorContentRegion:
        selector: '#author_content_region'

      placesRegion:
        selector: '#places_region'
        #regionClass: PlacesRegion

      placePassagesRegion:
        selector: '#place_passages_region'
        # regionClass: @FaderRegion

      worksRegion:
        selector: '#works_region'

      modalRegion: new ModalRegion
        selector: '#modal'

    App.module('HeaderApp').start()
    App.module('ContentApp').start()
    App.module('AuthorsApp').start()
    App.module('WorksApp').start()
    # App.module('PlacesApp').start()
    App.module('MapApp').start()

  # App.on 'initialize:after', ->
  App.on 'start', ->
    # console.log "App started"
    if Backbone.history
      return Backbone.history.start()
    return

  App
