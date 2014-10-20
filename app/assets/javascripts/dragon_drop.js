$(document).ready(function() {
  $('.dragon-drop').draggable({helper: "clone"});

  $('body').on('dragstart', '.dragon-drop', function() {
    $('.dragon-drop').draggable({helper: "clone"});
    $('.actionable').droppable({
      drop: function( event, ui ) {
        var draggable = ui.draggable.clone();
        $(this).append(draggable)      
      }
    });
  });
});


// function InviteeList() {
  // this.list = $('#invitees-list .dragon-drop');
  // this.dragonify = function() {
  // list.each(function(index) {
    // var inviteeId = list[index].attr('id');
    // $('#invitees-list #'+inviteeId).draggable({helper: "clone"});
  // });
  // }

// InviteeList.prototype.generateList = function() {
// }

// InviteeList.prototype.dragonify = function() {
//   this.list.each(function(item, index) {
//     // console.log(list[index].attr('id'))
//     var inviteeId = item.id
//   });
// }
