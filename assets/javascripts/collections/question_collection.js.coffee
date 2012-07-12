jQuery ->
  class QuestionCollection extends Backbone.Collection
    model: Question
    
    comparator: (model, model2) =>
      model.get('position') - model2.get('position')

  window.QuestionCollection = QuestionCollection
  