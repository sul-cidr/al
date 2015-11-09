@AL.module "WorksApp", (WorksApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false


  class WorksApp.Router extends Marionette.AppRouter
    appRoutes:
      "work/:work_id": "passWorkModel"
      # "workpassages/:work_id": "workPassages"

  API =
    startWorks: ->
      # console.log 'API.startWorks fired'
      AL.WorksApp.List.Controller.startWorks()
      # WorksApp.List.Controller.startWorks()

    passWorkModel: (work_id) ->
      App.vent.trigger "map:reset"
      # forwards work model to showWork function
      App.request "work:entity", work_id, (work) =>
        WorksApp.Show.Controller.showWork(work)

        # return work-in-focus to any
        # App.reqres.setHandler "work:model", ->
        #   return work

  WorksApp.on "start", ->
    new WorksApp.Router
      controller: API

  # App.addInitializer ->
  #   new WorksApp.Router
  #     controller: API
  #   API.startWorks()
