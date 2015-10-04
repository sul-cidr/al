@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showAuthor: (author) ->
      id = author.get("author_id")
      prefname = author.get("prefname")
      # console.log 'showAuthor: '+ id, prefname
      @authorLayout = @getAuthorLayout author

      @authorLayout.on "show", =>
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
        # wont show/render twice without reset
        if App.authorContentRegion.$el.length >0
          App.authorContentRegion.reset()
        bioPassagesView = @getBioPassagesView bio_passages
        # console.log 'listBioPassages(), '+ bio_passages.length + ' for ' + author_id
        window.passb = bioPassagesView
        # console.log 'bioPassagesView:', bioPassagesView.collection
        App.authorContentRegion.show bioPassagesView

    getBioPassagesView: (bio_passages) ->
      new Show.Passages
        collection: bio_passages
        viewComparator: "passage_id"

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

    listWorks: (author) ->
      id = author.get("author_id")
      App.request "work:entities", id, (works) =>
        # console.log 'listWorks()', works
        if App.authorContentRegion.$el.length > 0
          App.authorContentRegion.reset()
        @worksView = @getWorksView works
        # console.log 'listWorks(), '+ works.length + ' for ' + author_id
        App.authorContentRegion.show @worksView

    getWorksView: (works) ->
      new Show.Works
        collection: works
        viewComparator: "title"

    listWorkPassages: (work) ->
      id = work.get("work_id")
      # console.log 'Show.Controller.listWorkPassages() for',work_id
      App.request "passage:entities", id, "work", (work_passages) =>
        # wont show/render twice without reset
        if App.authorContentRegion.$el.length >0
          App.authorContentRegion.reset()
        workPassagesView = @getWorkPassagesView work_passages, work
        # console.log 'listWorkPassages(), '+ work_passages.length + ' for ' + id
        App.authorContentRegion.show workPassagesView
        # TODO: show Passages tab if it was hidden
        $("#passages_pill").removeClass("hidden")

    getWorkPassagesView: (work_passages, work) ->
      new Show.Passages ({
        model: work
        collection: work_passages
        viewComparator: "passage_id"
      })
