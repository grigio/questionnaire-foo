jQuery ->
  class Questionnaire extends Backbone.Collection
    model: Section
    
    comparator: (model, model2) =>
      model.get('position') - model2.get('position')
      
  window.Questionnaire = Questionnaire