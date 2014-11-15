$(document).ready(function() {
  $("body").on('focusout', '.edit_agenda', function() {
    saveAgenda($(this));
  });
  
  $("body").on("keypress", ".edit_agenda", function(event) {
    if (event.keyCode == 13) {
      event.preventDefault();
      saveAgenda($(this));
    }
  });

  $("#new-agenda-topic").on('ajax:beforeSend', function(event, xhr) {
    var agendaContent = $("#new-agenda-form #content_").val();
    if (agendaContent.trim().length < 1) {
      xhr.abort();
      $("#agenda-error").text('An agenda topic cannot be blank!');
    } else {
      $("#agenda-error").text('');
    }
  });
});

function saveAgenda(agenda) {
  var agendaId = $(agenda).parent().parent().attr('id');
  var agendaContent = $(agenda).context.innerText;
  var meetingId = $("#meeting-id").text();
  $.ajax({
    type: "PATCH",
    url: "/meetings/" + meetingId + "/agenda_topics/" + agendaId,
    data: { 'content': agendaContent }
  });
}