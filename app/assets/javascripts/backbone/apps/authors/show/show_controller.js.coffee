@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showAuthor: (author) ->
      # get map to filter for author
      console.log "showAuthor", author
      # trigger for map_app
      # App.vent.trigger "author:show", author

      id = author.get("author_id")
      prefname = author.get("prefname")
      # console.log 'showAuthor: '+ id, prefname
      @authorLayout = @getAuthorLayout author
      # console.log '@authorLayout', @authorLayout

      @authorLayout.on "show", =>
        # AL.ContentApp.Show.Controller.showTab('authors')
        # Backbone.history.navigate("authors/"+id)
        @showTitle author
        @showNav author
        @listBioPassages author
        # @listWorks id

      App.authorsRegion.show @authorLayout

    getAuthorLayout: (author) ->
      new Show.Layout ({
        model: author
      })

    listBioPassages: (author) ->
      id = author.get("author_id")
      # console.log 'List.Controller.listPassages() for ',author_id
      App.request "passage:entities", id, "bio", (bio_passages) =>
        console.log bio_passages
        # wont show/render twice without reset
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()

        bioPassagesView = @getBioPassagesView bio_passages, 'bio'
        # console.log 'listBioPassages(), '+ bio_passages.length + ' for ' + author_id
        window.passb = bioPassagesView
        # console.log 'bioPassagesView:', bioPassagesView.collection
        App.authorContentRegion.show bioPassagesView

    getBioPassagesView: (bio_passages, type) ->
      new Show.Passages
        collection: bio_passages
        viewComparator: "passage_id"
        className: if type == 'works' then 'passages-works' else 'passages-bio'

    # TODO: make this display a visualization summary
    listWorks: (author) ->
      id = author.get("author_id")
      console.log 'listWorks()', id
      App.request "works:author", id, (works) =>
        console.log 'listWorks() '+ id, works
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        @worksView = @getWorksView works

        # get work_ids
        window.work_ids = []
        _.each works.models, (w) =>
          work_ids.push w.attributes.work_id
        # console.log 'works:',work_ids
        # console.log works.length + ' works for ' + author_id
        App.authorContentRegion.show @worksView

    getWorksView: (works) ->
      new Show.Works
        collection: works
        viewComparator: "title"

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
        $(".passages-works h4").html('from <em>'+title+'</em')

    getWorkPassagesView: (work_passages, type) ->
      new Show.Passages ({
        collection: work_passages
        viewComparator: "passage_id"
        className: if type == 'works' then 'passages-works' else 'passages-bio'
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
