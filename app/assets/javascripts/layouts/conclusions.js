$(document).ready(function() {
  $("#agendas").on("keypress", ".edit_conclusion", function(event) {
    if (event.keyCode == 13) {
      event.preventDefault();
      saveConclusion($(this));
    }
  });
  $("#agendas").on("focusout", ".edit_conclusion", function() {
    saveConclusion($(this));
  });
});

function focusOn(conclusion) {
  var conclusionId = $(conclusion).attr('id');
  $('.conclusion#'+conclusionId).find(".edit_conclusion").focus();
}

function saveConclusion(conclusion) {
  var conclusionId = $(conclusion).parent().attr('id');
  var meetingId = $('#meeting-id').text();
  var agendaId = $(conclusion).parents('.agenda').attr('id');
  var input = $.trim($(conclusion).text());
  var response = $.ajax({
    type: "PATCH",
    url: "/meetings/"+meetingId+"/agenda_topics/"+agendaId+"/conclusions/"+conclusionId,
    data: {content: input, id: conclusionId}
  });
}
