$(document).ready(function() {
  $("#agendas").on("focusout", ".edit_conclusion", function() {
    var conclusionId = $(this).parent().attr('id');
    var meetingId = $('#meeting-id').text();
    var agendaId = $(this).parents('.agenda').attr('id');
    var input = $.trim($(this).text());
    var response = $.ajax({
      type: "PATCH",
      url: "/meetings/"+meetingId+"/agenda_topics/"+agendaId+"/conclusions/"+conclusionId,
      data: {content: input, id: conclusionId}
    });
  });

  $('.add_conclusion').bind("ajax:success", function(evt, data, status, xhr) {
    console.log(data);
  });


  // $('body').on('click', '.add_conclusion', function () {
  //   var response = $.ajax({
  //     type: ""
  //   })
  // })
});