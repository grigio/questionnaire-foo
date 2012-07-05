
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
    
    initialize: ->
      @collection = new QuestionCollection
      
    addQuestion: (attributes) =>
      question = new Question attributes
      question.set id: (@collection.length + 1)
      @collection.add question

  class QuestionView extends Backbone.View
    initialize: ->
      @model.bind 'change', @render
      @model.bind 'remove', @unrender
      
    render: =>
      type = @model.get 'type'
      id   = @model.get 'id'
      text = @model.get 'text'
      template  = _.template $("##{type}-template").html(), id: id, text: text
      $(@el).html template
      @
      
    unrender: =>
      $(@el).remove()
      
    remove: =>
      @model.destroy()
      
    startEditing: =>
      editView = new InlineEditView editElement: @$('.control-label'), model: @model, fieldName: 'text'
      editView.render()

    events:  
      'click .close': 'remove'
      'dblclick .control-label': 'startEditing'
  
  class QuestionCollection extends Backbone.Collection
    model: Question
      
  class SectionView extends Backbone.View
    tagname: 'fieldset'
    className: "section"
    template: _.template $("#section-template").html()
    
    initialize: ->
      @model.bind 'change', @render
      @model.bind 'remove', @unrender
      @model.collection.bind 'add', @appendQuestionView

    appendQuestionView: (question) =>
      q_view = new QuestionView model: question
      $(@el).append q_view.render().el
  
    render: =>
      $(@el).attr 'id', "section-#{@model.id}"
      $(@el).html @template(id: @model.id, legend: @model.get 'legend')
      $(@el).droppable hoverClass: "hover", scope: 'section'
      @
    
    unrender: =>
      $(@el).remove()
    
    remove: =>
      @model.destroy()
    
    startEditing: =>
      editView = new InlineEditView editElement: @$('.legend-text'), model: @model, fieldName: 'legend'
      editView.render()
      
    events:
      'drop': (event, ui) ->
        @model.addQuestion type: ui.draggable.attr('id')
      'click .close': 'remove'
      'dblclick .legend-text': 'startEditing'

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
    

  # Initialize the questionnaire container.
  questionnaireView = new QuestionnaireView
  
  # Insert the default components.
  section = new Section
  questionnaireView.add(section)
    # questionnaireView.add('text')
    # questionnaireView.add('score-question')
  
  # Set up the JQuery UI drag-and-drop interface.
  $(".draggable").draggable helper: "clone", opacity: 0.6
  $(".section-draggable").draggable helper: "clone", opacity: 0.6, scope: 'section'

  $("#questionnaire-pane").sortable axis: 'y', distance: 20, items: '.section', revert: true

  $(questionnaireView.el).droppable accept: "#section", drop : (event, ui) =>
    questionnaireView.add new Section
    true
