jQuery ->
  class QuestionCollection extends Backbone.Collection
    model: (attrs, options) ->
      switch attrs.type
        when 'radio-question' then new RadioQuestion attrs, options
        else new Question attrs, options

    comparator: (model, model2) =>
      model.get('position') - model2.get('position')


  window.QuestionCollection = QuestionCollection
