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
});