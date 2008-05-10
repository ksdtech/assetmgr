// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function check_all(form) {
  Form.getInputs(form, 'checkbox').each(
    function(chk) {
      chk.checked = true; 
    })
}

function clear_all(form) {
  Form.getInputs(form, 'checkbox').each(
    function(chk) {  chk.checked = false; })
}

function toggle_all(form) {
  Form.getInputs(form, 'checkbox').each(
    function(chk) { chk.checked = !chk.checked; })
}

function do_reset_bonjour() {
  $('asset_unix_hostname').value = '';
  return true;
}

function set_today(model, atrib) {
	var dt = new Date(); 
  $(model + '_' + atrib + '_3i').selectedIndex = dt.getDate();
  $(model + '_' + atrib + '_2i').selectedIndex = dt.getMonth() + 1;
	var t1 = $(model + '_' + atrib + '_1i')
	for (var i = 0; i < t1.length; i++) {
		if (t1.options[i].text == dt.getFullYear()) { t1.selectedIndex = i; }
	} 
}

function complete_ticket() {
  $('ticket_notify_requestor').enable();
  $('ticket_status').selectedIndex = 2;
	set_today('ticket', 'date_completed');
}

