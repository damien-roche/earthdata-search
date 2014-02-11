ns = @edsc.models.ui

ns.ProjectList = do (ko, window, $ = jQuery) ->
  class ProjectList
    constructor: (@project, @user, @datasetResults) ->
      @visible = ko.observable(false)

      @downloadableDatasets = ko.computed(@_computeDownloadableDatasets, this, deferEvaluation: true)

    showProject: =>
      @visible(true)

    hideProject: =>
      @visible(false)

    loginAndDownloadDataset: (dataset) =>
      @user.loggedIn =>
        @downloadDatasets([dataset])

    loginAndDownloadProject: =>
      @user.loggedIn =>
        @downloadDatasets(@project.getDatasets())

    downloadDatasets: (datasets) =>
      $project = $('#data-access-project')

      $project.val(JSON.stringify(@project.serialize()))

      $('#data-access').submit()

    toggleDataset: (dataset) =>
      project = @project
      if project.hasDataset(dataset)
        project.removeDataset(dataset)
        if @visible()
          @datasetResults.removeVisibleDataset(dataset)
      else
        project.addDataset(dataset)

    _computeDownloadableDatasets: ->
      dataset for dataset in @project.datasets() when dataset.granuleAccessOptions().canDownload

  exports = ProjectList
