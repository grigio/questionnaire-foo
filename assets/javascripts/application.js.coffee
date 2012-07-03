
//= require ../vendor/bootstrap.js
//= require ../vendor/underscore-min.js
//= require ../vendor/backbone-min.js

# Replace the default <%= %> interpolation
# with {{ }} style ones, to avoid erb errors.
_.templateSettings = {
  interpolate : /\{\{(.+?)\}\}/g
};

jQuery ->

  class Question extends Backbone.Model
    defaults:
      id: 1
      type: 'text-question'
      text: 'Question'

  class QuestionView extends Backbone.View
    initialize: ->
      _.bindAll @

    render: ->
      type = @model.get 'type'
      id   = @model.get 'id'
      text = @model.get 'text'
      template = _.template $("##{type}-template").html(), id: id, text: text
      $(@el).html template
      @

  class Questionnaire extends Backbone.Collection
    model: Question

  class QuestionnaireView extends Backbone.View
    el: $ '#questionnaire-pane'
    initialize: ->
      _.bindAll @
      @collection = new Questionnaire
      @collection.bind 'add', @appendQuestion

    add: (type) ->
      question = new Question type: type
      question.set id: (@collection.length + 1)
      @collection.add question
      
    appendQuestion: (question) ->
      q_view = new QuestionView model: question
      $(@el).append q_view.render().el


  questionnaire = new QuestionnaireView

  $(".draggable").draggable helper: "clone", opacity: 0.6

  $(questionnaire.el).droppable drop : (event, ui) =>
    type = ui.draggable.attr('id')
    questionnaire.add(type)
    true