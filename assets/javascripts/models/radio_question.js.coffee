jQuery ->
  class RadioQuestion extends Question
    defaults:
      type: 'radio-question'
      text: 'Choose between:'
    
    initialize: ->
      @answers = new AnswerCollection([
        {questionID: @cid, text: 'Yes'},
        {questionID: @cid, text: 'No'},
        {questionID: @cid, text: 'Not Applicable'}
      ])

    # Default toJSON method:
    # toJSON : function() {
    #   return _.clone(this.attributes);
    # }
    toJSON: =>
      _.clone position: @attributes.position, text: @attributes.text, answers: @answers.toJSON()

  window.RadioQuestion = RadioQuestion
  
  class Answer extends Backbone.Model
  class AnswerCollection extends Backbone.Collection
    model: Answer