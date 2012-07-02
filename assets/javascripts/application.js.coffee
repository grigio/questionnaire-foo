
//= require ../vendor/bootstrap.js
//= require ../vendor/underscore-min.js
//= require ../vendor/backbone-min.js

jQuery ->

  class Questionnaire extends Backbone.View
    el: $ '#questionnaire-pane'
    initialize: ->
      _.bindAll @
      @counter = 0
      @render()

    render: ->
      $(@el).append '<ul><li>Hi! Imma list!</li></ul>'

    addQuestion: ->
      @counter++
      $(@el).find('ul').append "<li>Hello, Backbone #{@counter}!</li>"

  questionnaire = new Questionnaire

  $(".draggable").draggable helper: "clone", opacity: 0.6

  $(questionnaire.el).droppable drop : (event, ui) =>
    console.log $(ui.draggable)
    questionnaire.addQuestion()
    true