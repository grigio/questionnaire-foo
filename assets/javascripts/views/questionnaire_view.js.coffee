jQuery ->
  class QuestionnaireView extends Backbone.View
    el: $ '#questionnaire-pane'

    initialize: ->
      @collection = new Questionnaire
      @collection.bind 'add', @appendSectionView
      @collection.bind 'reset', @rerender
      
      $(@el).droppable accept: "#section", drop: (event, ui) ->
        @add new Section
        true

    add: (section) =>
      section.set position: (@collection.length + 1)
      @collection.add section
      @collection.sort()

    appendSectionView: (section) =>
      section_view = new SectionView model: section
      $(@el).append section_view.render().el
    
    rerender: =>
      @$('.section').remove()
      @appendSectionView(section) for section in @collection.models

    events:
      'sortstop': (event, ui) ->
        @collection.getByCid(domID.replace('section-', '')).set(position: i+1) for domID, i in $(@el).sortable('toArray')
        @collection.sort()
        
  window.QuestionnaireView = QuestionnaireView