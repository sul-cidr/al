@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showAuthor: (author) ->
      # console.log "showAuthor", author.get('surname')
      # hide dimension dropdowns
      # $("#dimensions_region").addClass("hidden")

      # disable dimension dropdowns
      $(".btn").disable(true)

      id = author.get("author_id")
      prefname = author.get("prefname")
      # console.log 'showAuthor: '+ id, prefname
      @authorLayout = @getAuthorLayout author
      # console.log '@authorLayout', @authorLayout

      @authorLayout.on "show", =>
        @showTitle author
        @showNav author
        @listBioPassages author
        # @listWorks id
        $("#author_crumbs").append(
          '<span id="crumb_author" class="crumb-left" val="'+id+'">:: '+author.get("surname")+
          ' :: Biography'+
          '</span>')
        # $("#spin_authors").addClass('hidden')

      App.authorsRegion.show @authorLayout

      # trigger for map_app
      # sending one here
      App.vent.trigger "authors:show", author.get("author_id")
      # App.vent.trigger "author:show", author.get("author_id")

    getAuthorLayout: (author) ->
      new Show.Layout ({
        model: author
      })

    listBioPassages: (author) ->
      id = author.get("author_id")
      # console.log 'List.Controller.listPassages() for ',author_id
      App.request "passage:entities", id, "bio", (bio_passages) =>
        # console.log bio_passages
        # wont show/render twice without reset
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()

        bioPassagesView = @getBioPassagesView bio_passages, 'bio'
        # console.log 'listBioPassages(), '+ bio_passages.length + ' for ' + author_id
        window.passb = bioPassagesView
        # expose for disambiguating placeref selection on click
        App.reqres.setHandler "activework:id", ->
          return bioPassagesView.collection.models[0].attributes.work_id

        App.authorContentRegion.show bioPassagesView

    getBioPassagesView: (bio_passages, type) ->
      new Show.Passages
        collection: bio_passages
        viewComparator: "passage_id"
        className: 'passages-bio'

    listWorks: (author) ->
      id = author.get("author_id")
      # console.log 'listWorks()', id
      App.request "works:author", id, (works) =>
        # console.log 'listWorks() '+ id, works
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        @worksView = @getWorksView works
        window.works = works
        # get work_ids
        window.work_ids = []
        _.each works.models, (w) =>
          work_ids.push w.attributes.work_id
        App.authorContentRegion.show @worksView

    getWorksView: (works) ->
      new Show.Works
        collection: works
        viewComparator: "sorter"

    listWorkPassages: (work) ->
      id = work.get("work_id")
      title = work.get("title")
      # console.log 'Show.Controller.listWorkPassages() for',work_id
      App.request "passage:entities", id, "work", (work_passages) =>
        # wont show/render twice without reset
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        workPassagesView = @getWorkPassagesView work_passages, 'works'
        # console.log 'listWorkPassages(), '+ work_passages.length + ' for ' + id
        App.authorContentRegion.show workPassagesView
        # TODO: show Passages tab if it was hidden
        $("#passages_pill").removeClass("hidden")
        $(".work-title").html('from <em>'+title+'</em')

    getWorkPassagesView: (work_passages, type) ->
      new Show.Passages ({
        collection: work_passages
        viewComparator: "passage_id"
        className: 'passages-works'
      })


    showTitle: (author) ->
      @titleView = @getTitleView author
      @authorLayout.titleRegion.show @titleView

    getTitleView: (author) ->
      new Show.Title
        model: author

    showNav: (author) ->
      @navView = new Show.Pills
        model: author
      @authorLayout.navRegion.show @navView
