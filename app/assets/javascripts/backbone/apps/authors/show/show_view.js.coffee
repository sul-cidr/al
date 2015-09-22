@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.AuthorLayout extends Marionette.ItemView
    template: "authors/show/templates/show_author"

  class Show.Author extends Marionette.ItemView
    template: "authors/show/templates/show_author"
    events:
      "#toggle-authors click": "onToggle"

    onToggle: ->
      console.log 'onToggle()'
      if $('#authors').offset().left == 0
        console.log '.closer click to left'
        $('#authors').animate { 'left': -($('#authors').width() - 12) }, 500
        # $(".closer").attr("class","closer fa fa-caret-square-o-right");
      else if $('#authors').offset().left < 0
        console.log '.closer click to right'
        $('#authors').animate { 'left': 0 }, 500

  # AppLayoutView = Marionette.LayoutView.extend(
  #   template: 'authors/show/templates/show_authors'
  #   regions:
  #     title: '#authors-top'
  #     main: '#authors-content')
  # layoutView = new AppLayoutView
  # layoutView.render()
