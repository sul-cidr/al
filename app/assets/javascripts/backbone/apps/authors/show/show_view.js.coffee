@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  # just make any d3 thing repeat in a child
  # child of Show.Works
  class Show.D3Thing extends App.Views.ItemView
    template: "authors/show/templates/_work"
    el: 'svg'
    initialize: ->
      @d3 = d3.select(@el)
    #   return
    # events: 'click': 'makeCircle'
    # makeCircle: ->
    #   circ = @d3.append('circle')
    #   view = new CircleView(el: circ[0])
    #   view.render()
    #   return

  # experiment
  class Show.CloudBase extends App.Views.ItemView
    defaults: {
      margin: {top: 5, right: 5, bottom: 5, left: 5}
      # others specific to word clouds
    }
    render: ->
      margin = this.defaults.margin;
      this.width = this.$el.width() - margin.left - margin.right;
      this.height = this.$el.height() - margin.top - margin.bottom;

      this.svg = d3.select(this.el).append("svg")
          .attr("width", this.width + margin.left + margin.right)
          .attr("height", this.height + margin.top + margin.bottom)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    renderData: ->
      chart = this
      x = this.scales.x
      y = this.scales.y

      this.svg.selectAll(".bar")
          .data(this.mapData()) // { x: xAttr, y: yAttr }
        .enter().append("rect")
          .attr("class", "bar")
          .attr("x", ->
            return x(d.x) )
          .attr("width", x.rangeBand())
          .attr("y", ->
            return y(d.y); )
          .attr("height", (d) ->
            return chart.height - y(d.y); );
      return this;

  class Show.Layout extends App.Views.Layout
    template: "authors/show/templates/show_layout"
    # template: "authors/show/templates/show_author"
    regions:
      titleRegion: "#title_region"
      navRegion: "#nav_region"
      authorContentRegion: "#author_content_region"

  class Show.Title extends App.Views.ItemView
    template: "authors/show/templates/_title"
    events:
      "click .crumb-left": "goHome"

    goHome: ->
      # restore dimensions dropdowns
      $("#dimensions_region").show()
      # execute startAuthors()
      Backbone.history.history.back()
      # Backbone.history.navigate("authors", true)
      App.vent.trigger("map:reset")

  class Show.Pills extends App.Views.ItemView
    template: "authors/show/templates/_nav"
    events: {
      "click li": "loadContent"
    }
    loadContent: (e) =>
      $(".nav-pills li").removeClass("active")
      $(e.currentTarget).addClass("active")
      authid = App.request("author:model").get("author_id")
      @pill = $(e.currentTarget).context.attributes.value.value
      if @pill == 'works'
        @route = "works/"+authid
        console.log 'loadContent, works:', @route
        # CHECK: is this Navigate...true right?
        Backbone.history.navigate(@route, true)
        # Show.Controller.listWorks authid
      else if @pill == 'biography'
        @route = "authors/"+authid
        console.log 'loadContent, bio:', @route
        Backbone.history.navigate(@route, true)
        # Show.Controller.showAuthor authid

  class Show.Passage extends App.Views.ItemView
    template: "authors/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.placeref": "onPlacerefClick"
      "mouseenter span.placeref": "onPlacerefEnter"
      "mouseleave span.placeref": "onPlacerefLeave"
    }

    onPlacerefClick: (e) ->
      window.context = $(e.currentTarget).context
      id = $(e.currentTarget).context.attributes.val.value
      console.log 'onPlaceRefClick', id

      App.vent.trigger('placeref:click', id);

    onPlacerefEnter: (e) ->
      window.context = $(e.currentTarget).context
      id = $(e.currentTarget).context.attributes.val.value
      console.log 'onPlaceRefEnter', id

      App.vent.trigger('placeref:highlight', id);
      # App.vent.trigger('placeref:hover', e)

    onPlacerefLeave: (e) ->
      id = $(e.currentTarget).context.attributes.val.value
      console.log 'onPlaceRefLeave', id
      App.vent.trigger('placeref:unhighlight', id);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

  # passages are shown by clicking a work
  class Show.Passages extends App.Views.CompositeView
    template: "authors/show/templates/_passages"
    childView: Show.Passage
    childViewContainer: "div"

  class Show.Work extends App.Views.ItemView
    template: "authors/show/templates/_work"
    tagName: "span"
    events: {"click": "loadPassages"}
    loadPassages: ->
      work = this.model
      # show tab CHECK: leave visible?
      $("#passages_pill").removeClass("hidden")
      $(".nav-pills li").removeClass("active")
      $("#passages_pill").addClass("active")
      # use route for model attributes and navigation
      Backbone.history.navigate("workpassages/a/"+work.get('work_id'), true)

  class Show.Works extends App.Views.CompositeView
    template: "authors/show/templates/_works"
    className: 'works'
    # childView: Show.D3Thing
    childView: Show.Work
    childViewContainer: "div"
