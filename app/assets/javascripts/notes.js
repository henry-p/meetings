$(document).ready(function() {
  // $('#notes').on('keypress', function(e) {
  //   if (e.which == 13) {
  //     e.preventDefault();
  //     $(this).val($(this).val() + ',');
  //     // $('#notes').createRange().pasteHTML('<br>')
  //   }
  // })
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