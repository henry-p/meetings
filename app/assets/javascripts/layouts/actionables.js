$(document).ready(function() {
  $("#actionables").on("focusout", ".actionable", function() {
    saveActionable($(this));
  });

  $("#actionables").on("keypress", ".actionable", function(event) {
    if (event.keyCode == 13) {
      event.preventDefault();
      saveActionable($(this));
    }
  });

  $("#new_actionable").on('ajax:beforeSend', function(event, xhr) {
    var actionableContent = $("#actionable_content").val();
    if (actionableContent.trim().length < 1) {
      xhr.abort();
      $("#actionables-error").text('An actionable cannot be blank!');
    } else {
      $("#actionables-error").text('');
    }
  });  
});

function saveActionable(actionable) {
  var actionableId = $(actionable).attr('id');
  var meetingId = $('#meeting-id').text();
  var input = $(actionable).find(".editable").text();
  $.ajax({
    type: "PATCH",
    url: "/meetings/"+meetingId+"/actionables/"+actionableId,
    data: {content: input, id: actionableId}
  });
}