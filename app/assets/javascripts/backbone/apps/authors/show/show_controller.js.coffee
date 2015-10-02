@AL.module 'AuthorsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showAuthor: (author) ->
      id = author.get("author_id")
      @authorLayout = @getAuthorLayout author

      @authorLayout.on "show", =>
        @showTitle author
        @showNav()
        @listBioPassages id
        # @listWorks id

      App.authorsRegion.show @authorLayout

    getAuthorLayout: (author) ->
      new Show.Layout ({
        model: author
      })

    listBioPassages: (author_id) ->
      # console.log 'List.Controller.listPassages() for ',author_id
      App.request "passage:entities", author_id, "bio", (bio_passages) =>
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
      console.log 'author prefname', author.get("prefname")

    getTitleView: (author) ->
      new Show.Title
        model: author

    showNav: ->
      @navView = new Show.Pills
      @authorLayout.navRegion.show @navView

    listWorks: (author_id) ->
      App.request "work:entities", author_id, (works) =>
        if App.worksRegion.$el.length >0
          App.worksRegion.reset()
        worksView = @getWorksView works
        # console.log 'listWorks(), '+ works.length + ' for ' + author_id
        App.worksRegion.show worksView

    getWorksView: (works) ->
      new Show.Works
        collection: works
        viewComparator: "title"

    listWorkPassages: (work) ->
      # console.log work
      id = work.attributes.work_id
      # console.log 'List.Controller.listWorkPassages() for',id
      App.request "passage:entities", id, "work", (work_passages) =>
        # wont show/render twice without reset
        if App.workPassagesRegion.$el.length >0
          App.workPassagesRegion.reset()
        workPassagesView = @getWorkPassagesView work_passages, work
        # console.log 'listWorkPassages(), '+ work_passages.length + ' for ' + id
        App.workPassagesRegion.show workPassagesView
        $("#somePills1 a[href='#pill-3']").tab('show')

    getWorkPassagesView: (work_passages, work) ->
      new Show.Passages ({
        model: work
        collection: work_passages
        viewComparator: "passage_id"
      })
