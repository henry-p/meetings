$(document).ready(function() {
  makeDroppable($(".actionable"));
  makeDraggable($('#invitees .dragon-drop'));
});

function makeDraggable(els) {
  els.draggable({
    helper: "clone",
    revert: "invalid"
  });
}

function makeDroppable(els) {
  var draggable
  var draggableId
  var meetingId 
  var actionableId
  els.droppable({
    helper: "clone",
    over: function(event, ui) {
      draggable = ui.draggable.clone()
      draggable.addClass("hover-drop")
      $(this).append(draggable);
    },
    out: function(event, ui) {
      $(".hover-drop").remove();
    },
    drop: function(event, ui) {
      draggableId = $(".hover-drop").attr('id');
      $('.draggable').draggable('disabled');
      meetingId = $('#meeting-id').text();
      actionableId = $(event.target).attr('id');
      $.ajax({
        url: "/meetings/"+meetingId+"/actionables/"+actionableId+"/responsibilities",
        type: "POST",
        data: {user_id: draggableId, actionable_id: actionableId}
      }).done(function() {$(".hover-drop").remove()});
    }
  });
}