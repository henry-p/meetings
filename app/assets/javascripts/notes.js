$(document).ready(function() {
  $('body').on('click', '#add-notes-link', function() {
    // event.preventDefault();
    // var railsSyntax = "<%= render partial: 'notes' %>"
    $('#notes-container').html($.parseHTML("<div id = 'notes'></div>"));
    $('#notes').html(railsSyntax);
  });
  $('body').on('focusout', '#notes textarea', function() {
    event.preventDefault();
    var meetingId = $("#meeting-id").text();
    var notesContent = $(this).val();
    $.ajax({
      type: "PATCH",
      url: "/meetings/"+meetingId+"/update_notes",
      data: {'notes': notesContent}
    });
  });
});