$(document).ready(function() {
  $("body").on('focusout', '.agenda .editable', function() {
    var agendaId = $(this).parent().parent().attr('id');
    var agendaContent = $(this).context.innerText;
    var meetingId = $("#meeting-id").text();
    console.log("/meetings/" + meetingId + "/agenda_topics/" + agendaId)
    $.ajax({
      type: "PATCH",
      url: "/meetings/" + meetingId + "/agenda_topics/" + agendaId,
      data: { 'content': agendaContent }
    });
  });
});