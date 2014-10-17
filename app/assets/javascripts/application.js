// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
//= require jquery-ui.min
//= require underscore.min
//= require jqueryui-multisearch.min

$(function() {
  $("#recipients").multisearch({
    source: localData,

    keyAttrs: ['id'],
    searchAttrs: ['display_name', 'primary_email'],
    formatPickerItem: _.template($('#contact-item').html()),
    formatSelectedItem: _.template($('#selected-item').html()),
    buildNewItem: function(text) {
      return {
        id: null,
        display_name: text,
        organization: '',
        primary_phone: '',
        primary_email: text
      };
    },

    adding: function(event, ui) {
      var validater = new RegExp('^(?:[^,]+@[^,/]+\.[^,/]+|)$');

      $(this).find('input').removeClass('error');
      if (ui.notfound) {
        if (!validater.test(ui.data.primary_email)) {
          $("#recipients").find('input').addClass('error');
          return false;
        }
      }
    },

  });
});

localData = [{
    "id": 1,
    "display_name": "Neal, Amelia R.",
    "organization": "XYZ Company",
    "primary_email": "pede@nibh.com",
    "primary_phone": "(577) 324-9152"
  },