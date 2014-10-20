$(document).ready(function() {
  $('.dragon-drop').draggable({helper: "clone"});

  $('body').on('dragstart', '.dragon-drop', function() {
    $('.actionable').droppable({
      drop: function( event, ui ) {
        var meetingId = $('#meeting-id').text();
        var draggable = ui.draggable.clone();
        var draggableId = draggable.attr('id');
        console.log(draggableId)
        var actionableId = $(event.target).attr('id');
        console.log(actionableId)
        $.ajax({
          url: "/meetings/"+meetingId+"/actionables/"+actionableId+"/responsibilities",
          type: "POST",
          data: {user_id: draggableId, actionable_id: actionableId}
        });
      }
    });
  });
});
