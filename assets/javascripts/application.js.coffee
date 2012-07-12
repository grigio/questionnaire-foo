
//= require ../vendor/bootstrap.js
//= require ../vendor/underscore-min.js
//= require ../vendor/backbone-min.js

//= require_tree './models'
//= require_tree './collections'
//= require_tree './views'

# Replace the default <%= %> interpolation
# with {{ }} style ones, to avoid erb errors.
_.templateSettings = {
  interpolate : /\{\{(.+?)\}\}/g
};

jQuery ->

  # Remove Backbone's 'send every change to the server' behaviour
  Backbone.sync = (method, model, success, error) ->
    success

  # Set up the JQuery UI drag-and-drop interface.
  $(".draggable").draggable helper: "clone", opacity: 0.6
  $(".section-draggable").draggable helper: "clone", opacity: 0.6, scope: 'section'

  $("#questionnaire-pane").sortable axis: 'y', distance: 20, items: '.section', revert: true

