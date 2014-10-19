$(document).ready(function() {
  $("#agendas").on("focusout", ".edit_conclusion", function() {
    var conclusionId = $(this).parent().attr('id');
    var meetingId = $('#meeting-id').text();
    var agendaId = $(this).parents('.agenda').attr('id');
    var input = $.trim($(this).text());
    $.ajax({
      type: "PATCH",
      url: "/meetings/"+meetingId+"/agenda_topics/"+agendaId+"/conclusions/"+conclusionId,
      data: {content: input, id: conclusionId}
    });
  });
});