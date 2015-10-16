// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#part_production_start_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_production_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_production_actual_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
   $("#part_production_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_production_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_production_o_finish_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_production_o_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
	$('#part_production_part_num').change(function() { 
	  $('#part_production_field_changed').val('part_num');
      $.get(window.location, $('form').serialize(), null, "script");
  	  return false;
	});
});
