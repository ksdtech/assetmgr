// alerts.js
// http://blog.andreasaderhold.com/2006/07/rails-notifications
// show, then hide any flash notices

Event.observe(window, 'load', function() { 
	show_alerts();
	window.setTimeout(fade_alerts, 3000);
});
function show_alerts() {
  $A(document.getElementsByClassName('alert')).each(function(o) { o.opacity = 100.0; });
}
function fade_alerts() {
  $A(document.getElementsByClassName('alert')).each(function(o) { new Effect.Fade(o, {duration: 1.0}); });
}
