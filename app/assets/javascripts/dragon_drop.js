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
  els.droppable({
    helper: "clone",
    hoverClass: "ui-state-hover",
    over: function(event, ui) {
      var draggable = ui.draggable.clone()
      draggable.addClass("hover-drop")
      $(this).append(draggable);
    },
    out: function(event, ui) {
      $(this).find($('.placeholder')).show();
      $(".hover-drop").remove();
    },
    drop: function(event, ui) {
      console.log($(event.target))
      var draggableId = $(".hover-drop").attr('id');
      $('.draggable').draggable('disabled');
      var meetingId = $('#meeting-id').text();
      var actionableId = $(event.target).attr('id');
      $.ajax({
        url: "/meetings/"+meetingId+"/actionables/"+actionableId+"/responsibilities",
        type: "POST",
        data: {user_id: draggableId, actionable_id: actionableId}
      }).done(function() {$(".hover-drop").remove()});
    }
  });
}