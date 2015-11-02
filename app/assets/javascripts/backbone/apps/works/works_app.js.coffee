@AL.module "WorksApp", (WorksApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false


  class WorksApp.Router extends Marionette.AppRouter
    appRoutes:
      "works": "startWorks"
      "works/:work_id": "passWorkModel"
      "workpassages/:work_id": "workPassages"

  API =
    startWorks: ->
      # console.log 'API.startWorks fired'
      AL.WorksApp.List.Controller.startWorks()
      # WorksApp.List.Controller.startWorks()

    workPassages: (work_id) ->
      App.request "work:entity", work_id, (work) =>
        WorksApp.Show.Controller.listWorkPassages(work)
        # returns current work from anywhere??
        App.reqres.setHandler "work:model", ->
          return work

    passWorkModel: (work_id) ->
      App.vent.trigger "map:reset"
      # forwards work model to showWork function
      App.request "work:entity", work_id, (work) =>
        # console.log 'API passing model to showWork'
        WorksApp.Show.Controller.showWork(work)
        # returns focus work from anywhere??
        App.reqres.setHandler "work:model", ->
          return work

  App.addInitializer ->
    new WorksApp.Router
      controller: API
    # CHECK: started by appRoute ""
    API.startWorks()
