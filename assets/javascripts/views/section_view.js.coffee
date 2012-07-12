jQuery ->
  class SectionView extends Backbone.View
    tagname: 'fieldset'
    className: "section"
    template: _.template $("#section-template").html()

    initialize: ->
      @model.bind 'change', @render
      @model.bind 'remove', @unrender
      @model.collection.bind 'add', @render

    appendQuestionView: (question) =>
      q_view = new QuestionView model: question
      $(@el).append q_view.render().el

    render: =>
      $(@el).attr 'id', "section-#{@model.cid}"
      $(@el).html @template(legend: @model.get('legend'))

      @appendQuestionView(question) for question in @model.collection.models

      $(@el).sortable axis: 'y', distance: 20, items: '.control-group', revert: true
      $(@el).droppable hoverClass: "hover", scope: 'section'
      @

    unrender: =>
      $(@el).remove()

    remove: (event) =>
      @model.destroy()

    startEditing: =>
      editView = new InlineEditView editElement: @$('.legend-text'), model: @model, fieldName: 'legend'
      editView.render()

    events:
      'sortstop': (event, ui) ->
        @model.collection.getByCid(domID.replace('question-', '')).set(position: i+1) for domID, i in $(@el).sortable('toArray')
        @model.collection.sort()
      'drop': (event, ui) ->
        @model.addQuestion type: ui.draggable.attr('id')
      'click [data-remove="section"]': 'remove'
      'dblclick .legend-text': 'startEditing'

  window.SectionView = SectionView