jQuery ->
  class Section extends Backbone.Model
    defaults:
      legend: 'Section'

    initialize: (attributes) ->
      questions = attributes.collection if attributes?
      @collection = new QuestionCollection questions

    addQuestion: (attributes) =>
      question = new Question attributes
      question.set position: (@collection.length + 1)
      @collection.add question
    
    # Default toJSON method:
    # toJSON : function() {
    #   return _.clone(this.attributes);
    # }
    toJSON: =>
      _.clone position: @attributes.position, legend: @attributes.legend, collection: @collection.toJSON()

  window.Section = Section