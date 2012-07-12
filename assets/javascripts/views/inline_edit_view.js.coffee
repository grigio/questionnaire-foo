jQuery ->
  class InlineEditView extends Backbone.View
    tagName: 'span'
    className: "inline-edit"
    template: _.template $("#inline-edit-template").html()

    initialize: (options)->
      @model = options.model
      @fieldName = options.fieldName
      @editElement = options.editElement

    value: =>
      @$('input').val()

    focusAndSelect: =>
      @$('input').focus().select()

    render: =>
      @editElement.hide()
      $(@el).attr 'id', "inline-edit-#{@model.cid}-container"
      $(@el).append @template(inputName: "inline-edit-#{@model.cid}", initialValue: @model.get(@fieldName))
      @editElement.after(@el)
      @focusAndSelect()
      @

    unrender: =>
      @model.set @fieldName, @value()
      $(@el).remove()
      @editElement.show()
      @

    events:
      'focusout': 'unrender'
      'keypress': (event) ->
        @unrender() if event.which == 13 # If the keypress was 'enter'

  window.InlineEditView = InlineEditView