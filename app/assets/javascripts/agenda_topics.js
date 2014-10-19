$(document).ready(function() {
  $("body").on('focusout', '.edit_agenda', function() {
    var agendaId = $(this).parent().parent().attr('id');
    var agendaContent = $(this).context.innerText;
    var meetingId = $("#meeting-id").text();
    $.ajax({
      type: "PATCH",
      url: "/meetings/" + meetingId + "/agenda_topics/" + agendaId,
      data: { 'content': agendaContent }
    });
  });
  
  $('body').on('click', '#new-agenda-link',function() {
    event.preventDefault();
    $("#new-agenda-form").show();
  });
  $("body").on("submit", "#new-agenda-form", function() {
    $(this).hide();
  });

  $("#new-agenda-form").on('ajax:beforeSend', function(event, xhr) {
    var agendaContent = $("#new-agenda-form #content_").val();
    if (agendaContent.trim().length < 1) {
      xhr.abort();
      $("#agenda-error").text('An agenda topic cannot be blank!');
    } else {
      $("#agenda-error").text('');
    }
  });
});