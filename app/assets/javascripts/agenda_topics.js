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

});