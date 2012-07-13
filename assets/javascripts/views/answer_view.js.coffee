jQuery ->
  class AnswerView extends Backbone.View
    tagName: 'label'
    className: 'radio inline'
    template: _.template $("#answer-template").html()

    initialize: ->
      @model.bind 'change', @render
      @model.bind 'remove', @unrender

    remove: =>
      @model.destroy()

    render: =>
      text = @model.get 'text'
      $(@el).html @template(questionID: @model.get('questionID'), text: text, value: text.replace(' ', '_').toLowerCase())
      @

    unrender: =>
      $(@el).remove()

    events:
      'click [data-remove="answer"]': 'remove'
  window.AnswerView = AnswerView