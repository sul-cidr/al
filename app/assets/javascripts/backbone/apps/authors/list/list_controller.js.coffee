@AL.module 'AuthorsApp.List', (List, App, Backbone, Marionette, $, _) ->

  $vent = new Backbone.Wreqr.EventAggregator();

  List.Controller =

    startAuthors: ->
      App.request "authors:category", 0, (authors) =>
      #repl App.request "author:entities", (authors) =>
        # console.log 'startAuthors>>authors: ', authors

        @layout = @getLayoutView()
        # console.log @layout

        @layout.on "show", =>
          @showTitle authors
          # @listCatAuthors 0
          @listCatAuthors authors, 0

          # @listAuthors authors, 'all'
          @listDimensions()
          # @listCategories()
          @listCategories("genre")

        App.authorsRegion.show @layout

    showTitle: (authors) ->
      headerView = @getTitleView authors
      @layout.headerRegion.show headerView

    listDimensions: ->
      # console.log 'showDimensions()'
      dimensionsView = new List.Dimensions
      @layout.dimensionsRegion.show dimensionsView

    listCategories: (dim) ->
      App.request "category:entities", (categories) =>
        # console.log 'listCategories for: ', dim
        categoriesView = @getCategoriesView categories, dim
        # categoriesView.on 'childview:authors:filtered', (childView, model) ->
        #   console.log 'heard trigger', model
        # console.log categoriesView
        @layout.categoriesRegion.show categoriesView

    getCategoriesView: (categories, dim) ->
      new List.Categories
        collection: categories
        filter: (child, index, collection) ->
          child.get('dim') == dim

    listWorks: (author_id) ->
      App.request "work:entities", author_id, (works) =>
        if App.worksRegion.$el.length >0
          App.worksRegion.reset()
        worksView = @getWorksView works
        # console.log 'listWorks(), '+ works.length + ' for ' + author_id
        App.worksRegion.show worksView

    getWorksView: (works) ->
      new List.Works
        collection: works
        viewComparator: "title"

    listBioPassages: (author_id) ->
      # console.log 'List.Controller.listPassages() for ',author_id
      App.request "passage:entities", author_id, "bio", (bio_passages) =>
        # wont show/render twice without reset
        if App.bioPassagesRegion.$el.length >0
          App.bioPassagesRegion.reset()
        bioPassagesView = @getBioPassagesView bio_passages
        # console.log 'listBioPassages(), '+ bio_passages.length + ' for ' + author_id
        window.passb = bioPassagesView
        # console.log 'bioPassagesView:', bioPassagesView.collection
        App.bioPassagesRegion.show bioPassagesView

    getBioPassagesView: (bio_passages) ->
      new List.Passages
        collection: bio_passages
        viewComparator: "passage_id"

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
      new List.Passages ({
        model: work
        collection: work_passages
        viewComparator: "passage_id"
      })

    showAuthor: (author) ->
      # console.log 'showAuthor()', author.attributes.author_id
      authorView = @getAuthorView author
      App.authorsRegion.show authorView
      @listBioPassages author.attributes.author_id
      @listWorks author.attributes.author_id

    getAuthorView: (author) ->
      # console.log author
      new List.AuthorLayout ({
        model: author
      })

    # category 0 = all
    listCatAuthors: (authors, category) ->
      # console.log 'authors in category#: ',category
      authorsCatView = @getCatAuthorsView authors, category
      #
      # console.log authorsCatView
      @layout.authorlistRegion.show authorsCatView


    getCatAuthorsView: (authors, category) ->
      # console.log 'getCategoriesView:',category
      new List.Authors
        collection: authors
        # filter: (child, index, collection) ->
        #   child.get('categories').indexOf(category) > -1;
          # console.log 'filtered author collection', authors

    getTitleView: (authors) ->
      new List.Title
        collection: authors

    getLayoutView: ->
      new List.Layout
