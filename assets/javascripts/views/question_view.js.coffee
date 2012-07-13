jQuery ->
  class QuestionView extends Backbone.View
    tagName: 'div'
    className: 'control-group'

    initialize: ->
      @model.bind 'change', @render
      @model.bind 'remove', @unrender

    render: =>
      $(@el).attr 'id', "question-#{@model.cid}"
      template  = _.template $("##{@model.get 'type'}-template").html(), id: @model.cid, text: @model.get 'text'
      $(@el).html template
      @

    unrender: =>
      $(@el).remove()

    remove: (event) =>
      @model.destroy()

    startEditing: =>
      editView = new InlineEditView editElement: @$('.editable'), model: @model, fieldName: 'text'
      editView.render()

    events:
      'click [data-remove="question"]': 'remove'
      'dblclick .editable': 'startEditing'

  window.QuestionView = QuestionView

  class RadioQuestionView extends QuestionView
    render: =>
      super()
      @appendAnswerView(answer) for answer in @model.answers.models
      @
    appendAnswerView: (answer) =>
      view = new AnswerView model: answer
      @$('.controls').append view.render().el


  window.RadioQuestionView = RadioQuestionView
