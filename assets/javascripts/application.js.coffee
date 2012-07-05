
//= require ../vendor/bootstrap.js
//= require ../vendor/underscore-min.js
//= require ../vendor/backbone-min.js

# Replace the default <%= %> interpolation
# with {{ }} style ones, to avoid erb errors.
_.templateSettings = {
  interpolate : /\{\{(.+?)\}\}/g
};

jQuery ->
  
  # Remove Backbone's 'send every change to the server' behaviour
  Backbone.sync = (method, model, success, error) ->
    success

  class Question extends Backbone.Model
    defaults:
      id: 1
      type: 'text-question'
      text: 'Question'
      
  class Section extends Backbone.Model
    defaults:
      id: 1
      legend: 'Section'

  class QuestionView extends Backbone.View
    initialize: ->
      @model.bind 'change', @render
      
    render: =>
      type = @model.get 'type'
      id   = @model.get 'id'
      text = @model.get 'text'
      template  = _.template $("##{type}-template").html(), id: id, text: text
      $(@el).html = template
      @
  
  class QuestionCollection extends Backbone.Collection
    model: Question
      
  class SectionView extends Backbone.View
    tagname: 'fieldset'
    className: "section"
    template: _.template $("#section-template").html()
    
    initialize: ->
      @collection = new QuestionCollection
      @collection.bind 'add', @appendQuestionView
    
      @model.bind 'change', @render
      @model.bind 'remove', @unrender

    addQuestion: (type) =>
      question = new Question type: type
      question.set id: (@collection.length + 1)
      @collection.add question

    appendQuestionView: (question) =>
      q_view = new QuestionView model: question
      $(@el).append q_view.render().el
  
    render: =>
      $(@el).attr 'id', "section-#{@model.id}"
      $(@el).html @template(id: @model.id, legend: @model.get 'legend')
      @
    
    unrender: =>
      $(@el).remove()
    
    remove: =>
      @model.destroy()
    
    startEditing: =>
      @$('.legend-text').hide()
      @$('.inline-edit').show().focus().select()
      
    finishEditing: =>
      @$('.legend-text').show()
      @$('.inline-edit').hide()
      @model.set legend: @$('.inline-edit').val()
      
    events:  
      'click .close': 'remove'
      'dblclick .legend-text': 'startEditing'
      'focusout .inline-edit': 'finishEditing'
      'keypress .inline-edit': (event) ->
        @finishEditing() if event.which == 13 # If the keypress was 'enter'

  class Questionnaire extends Backbone.Collection
    model: Section
    initialize: ->
      @sortedIDs = []
      this.bind 'destroy', @recalculateIDs
    
    recalculateIDs: =>
      model.set(id: i+1) for model, i in @models

  class QuestionnaireView extends Backbone.View
    el: $ '#questionnaire-pane'
    
    initialize: ->
      @collection = new Questionnaire
      @collection.bind 'add', @appendSectionView
    
    add: (section) =>
      section.set id: (@collection.length + 1)
      @collection.add section

    appendSectionView: (section) =>
      section_view = new SectionView model: section
      $(@el).append section_view.render().el
    
    events:
      'sortstop': (event, ui) ->
        ids = ( domID.replace('section-', '') for domID in $(@el).sortable('toArray') )
        @collection.sortedIDs = ids
    

  # Initialize the questionnaire container.
  questionnaireView = new QuestionnaireView
  
  # Insert the default components.
  section = new Section
  questionnaireView.add(section)
    # questionnaireView.add('text')
    # questionnaireView.add('score-question')
  
  # Set up the JQuery UI drag-and-drop interface.
  $(".draggable").draggable helper: "clone", opacity: 0.6
  $("#questionnaire-pane").sortable axis: 'y', distance: 20, items: '.section', revert: true
  
  $(questionnaireView.el).droppable accept: "#section", drop : (event, ui) =>
    questionnaireView.add new Section
    true