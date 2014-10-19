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
//= require private_pub
//= require bootstrap
//= require_tree .
//= require jquery-ui.min
//= require underscore.min
//= require jqueryui-multisearch.min
//= require moment.min
//= require bootstrap-datetimepicker.min
$(function() {
  var current_path = window.location.pathname;
  if (current_path === "/meetings/new" || /\/meetings\/\d+\/edit/.test(current_path)) {
    getAllContacts();
    contactsMultiSearchBox();
    makeWholeBoxClickable();
    makeDateTimePicker(datetimepicker_start, datetimepicker_end);
    submitFormEventHandler();
  }

  if (/\/meetings\/\d+\/edit/.test(current_path)) {
    getInvitedContacts(/\/meetings\/\d+/.exec(current_path)[0] + "/attendees");
    fillContactsBoxWithAttendees();
  }

  if (/\/meetings\/\d+/.test(current_path)) {
    showNameOnHover();
  }
});
