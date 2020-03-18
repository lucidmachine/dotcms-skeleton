

function init () {

}

var logWindow, outwindow;
(function() {
	document.addEventListener("DOMContentLoaded", function (e) {
		logWindow = $('#log');
		outWindow = $('#out');

		init();
	});
	
})();

function log (str) {
	let currentLog = $('#log').val();
	$('#log').val(str + "\n" + currentLog);
}