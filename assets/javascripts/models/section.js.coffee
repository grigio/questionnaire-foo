jQuery ->
  class Section extends Backbone.Model
    defaults:
      legend: 'Section'

    initialize: (attributes) ->
      questions = attributes.collection if attributes?
      @collection = new QuestionCollection questions

    addQuestion: (attributes) =>
      @collection.add type: attributes.type, position: (@collection.length + 1), text: 'Question'

    # Default toJSON method:
    # toJSON : function() {
    #   return _.clone(this.attributes);
    # }
    toJSON: =>
      _.clone position: @attributes.position, legend: @attributes.legend, collection: @collection.toJSON()

  window.Section = Section