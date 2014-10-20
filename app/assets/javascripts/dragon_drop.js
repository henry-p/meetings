$(document).ready(function() {
  $('#invitees .dragon-drop').draggable({helper: "clone"});

  $('body').on('dragstart', '.dragon-drop', function() {
    $('.actionable').droppable({
      drop: function( event, ui ) {
        $('.draggable').draggable('disabled');
        var meetingId = $('#meeting-id').text();
        var draggable = ui.draggable.clone();
        var draggableId = draggable.attr('id');
        var actionableId = $(event.target).attr('id');
        $.ajax({
          url: "/meetings/"+meetingId+"/actionables/"+actionableId+"/responsibilities",
          type: "POST",
          data: {user_id: draggableId, actionable_id: actionableId}
        });
      }
    });
  });
});
