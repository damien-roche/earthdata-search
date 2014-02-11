do (ko, $=jQuery) ->

  ko.observableArray.fn.contains = (obj) ->
    @indexOf(obj) != -1

  ko.observableArray.fn.isEmpty = (obj) ->
    this().length == 0

  # Valid names: 'added', 'deleted', 'retained'
  ko.observableArray.fn.subscribeChange = (status, callback) ->
    previousValue = null

    beforeChange = (oldValue) ->
      previousValue = oldValue.slice(0)

    afterChange = (latestValue) ->
      for {status, value} in ko.utils.compareArrays(previousValue, latestValue)
        callback?(value) if status == 'name'
      previousValue = null

    @subscribe(beforeChange, undefined, 'beforeChange')
    @subscribe(afterChange)

  ko.observableArray.fn.subscribeAdd = (callback) ->
    @subscribeChange('added', callback)

  ko.observableArray.fn.subscribeRemove = (callback) ->
    @subscribeChange('deleted', callback)


  ko.onDemandObservable = (callback, target) ->
    _value = ko.observable()

    result = ko.computed
      read: ->
        callback.call(target) unless result.loaded()
        _value()
      write: (newValue) ->
        result.loaded(true);
        _value(newValue)
      deferEvaluation: true

    result.loaded = ko.observable()
    result.refresh = -> result.loaded(false)

    result

  ko.bindingHandlers.showModal =
    init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->

    update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
      isShown = ko.unwrap(valueAccessor())
      if isShown
        method = 'show'
      else
        method = 'hide'
      $(element).modal(method)
