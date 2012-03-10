
$(document).ready(function() {
	$.getJSON('servers', function(data) {
		$('#status').append('<table><tr><th>Server</th><th>Last post</th><th>Uptime</th><th>Load</th></tr></table>');
		var table = $('#status table');
		$.each(data.servers, function(id, server) {
			table.append('<tr><td>' + server.name +'</td><td>'+ server.timestamp+'</td><td>'+server.uptime+'</td><td>'+server.load+'</td></tr>');
		});
	});
});
