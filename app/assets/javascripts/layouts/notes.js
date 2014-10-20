$(document).ready(function() {
  $('body').on('focusout', '#notes', function() {
    event.preventDefault();
    var meetingId = $("#meeting-id").text();
    var notesContent = $(this).html()
    $.ajax({
      type: "PATCH",
      url: "/meetings/"+meetingId+"/update_notes",
      data: {'notes': notesContent}
    });
  });
});