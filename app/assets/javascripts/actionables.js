$(document).ready(function() {
$("body").on("click", "#actionable_button", function() {
  alert("you win")
});

  $("body").on('focusout', '.agenda .editable', function() {
    var agendaId = $(this).parent().attr('id')
    var agendaContent = $(this).context.innerText
    $.ajax({

    });
  });
});