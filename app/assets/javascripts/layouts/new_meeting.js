function setSecondDatetimepickerTime() {
  $("#datetimepicker_start").blur(function(){
    var input = $(this).data("DateTimePicker").date._i;
    $('#datetimepicker_end').data("DateTimePicker").setDate(input);
  });
}