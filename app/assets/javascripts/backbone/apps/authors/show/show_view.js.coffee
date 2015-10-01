@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  # class List.AuthorLayout extends Marionette.ItemView
  #   template: "authors/show/templates/show_author"

  # class Show.AuthorLayout extends Marionette.ItemView
  #   template: "authors/show/templates/show_author"
  #   events:
  #     "click .toggle-authors": "onToggle"
  #     "click li#li_bio": "backNav"
  #     # "click a[href='#pill-1']": "backNav"
  #   backNav: ->
  #     console.log 'back'
  #
  #   onToggle: ->
  #     console.log 'toggle from show_view'
  #     if $('#authors').offset().left == 0
  #       console.log '.closer click to left'
  #       $('#authors').animate { 'left': -($('#authors').width() - 15) }, 500
  #       # $(".closer").attr("class","closer fa fa-caret-square-o-right");
  #     else if $('#authors').offset().left < 0
  #       console.log '.closer click to right'
  #       $('#authors').animate { 'left': 0 }, 500
