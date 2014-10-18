$(document).ready(function() {
  $("#actionables").on("focusout", ".actionable", function() {
    var actionableId = $(this).attr('id');
    var meetingId = $('#meeting-id').text();
    var input = $(this).find(".editable").text();
    $.ajax({
      type: "PATCH",
      url: "/meetings/"+meetingId+"/actionables/"+actionableId,
      data: {content: input, id: actionableId}
    });
  });

  $("#new_actionable").on('ajax:beforeSend', function(event, xhr) {
    var agendaContent = $("#actionable_content").val();
    if (agendaContent.trim().length < 1) {
      xhr.abort();
      $("#actionables-error").text('An actionable cannot be blank!');
    } else {
      $("#actionables-error").text('');
    }
  });  
});