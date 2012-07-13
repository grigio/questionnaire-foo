jQuery ->
  class RadioQuestion extends Question
    defaults:
      type: 'radio-question'
      text: 'Choose between:'

    initialize: (attributes) ->
      answers = if attributes? && attributes.answers? then attributes.answers else [
        {text: 'Yes'},
        {text: 'No'},
        {text: 'Not Applicable'}
      ]
      answers = ({text: answer.text, questionID: @cid} for answer in answers) if answers?
      @answers = new AnswerCollection(answers)

    # Default toJSON method:
    # toJSON : function() {
    #   return _.clone(this.attributes);
    # }
    toJSON: =>
      _.clone position: @attributes.position, text: @attributes.text, type: @attributes.type, answers: @answers.toJSON()

  window.RadioQuestion = RadioQuestion

  class Answer extends Backbone.Model
  class AnswerCollection extends Backbone.Collection
    model: Answer