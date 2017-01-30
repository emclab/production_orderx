// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#part_production_start_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_production_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_production_actual_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
   $("#start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#o_finish_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#o_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
	$('#part_production_part_num').change(function() { 
      $.get(window.location, {field_changed: 'part_num', part_num: $('#part_production_part_num').val()}, null, "script");
  	  return false;
	});
});
