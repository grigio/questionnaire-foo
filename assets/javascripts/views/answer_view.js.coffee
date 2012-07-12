jQuery ->
  class AnswerView extends Backbone.View
    tagName: 'label'
    className: 'radio inline'
    template: _.template $("#answer-template").html()
    
    render: =>
      text = @model.get 'text'
      $(@el).html @template(questionID: @model.get('questionID'), text: text, value: text.replace(' ', '_').toLowerCase())
      @
      
    events:
      'click [data-remove="answer"]': 'remove'
  window.AnswerView = AnswerView