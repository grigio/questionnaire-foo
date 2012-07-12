jQuery ->
  class Question extends Backbone.Model
  defaults:
    type: 'text-question'
    text: 'Question'

  window.Question = Question