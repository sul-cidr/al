@AL.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showHeader: ->
      headerView = @getHeaderView()
      App.headerRegion.show headerView

    getHeaderView: ->
      new Show.Header

    loadAbout: (e)->
      # e.preventDefault()
      @wHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
      # console.log 'resize to '+@wHeight*0.85
      if $("#about").height() < 100
        # $("#map_chooser").addClass('hidden')
        $("#about").animate({ height: @wHeight * 0.90 }, 500, ->
          $("#about_content").removeClass('hidden')
          # $("#map_chooser").addClass('hidden')
        )
        # $("#about_content").removeClass('hidden')
      else
        $("#about").animate({ height: '30px' }, 500, ->
          $("#about_content").addClass('hidden')
          # $("#map_chooser").removeClass('hidden')
        )


# HeaderApp.Show.Controller.displayModal()

$('#clickme').click ->
  $('#book').animate {
    opacity: 0.25
    left: '+=50'
    height: 'toggle'
  }, 5000, ->
    console.log 'do it'
    return
  return
