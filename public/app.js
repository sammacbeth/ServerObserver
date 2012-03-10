
var timeDiff = function(then, now) {
	var diff = now.getTime() - then.getTime();
	diff = Math.round(diff / 1000);
	return timeToDuration(diff);
}

var timeToDuration = function(seconds, units) {
	var minutes = 0,
		hours = 0,
		days = 0,
		duration = [];
	if(units == undefined)
		units = 2;
	if(seconds > 60*60*24) {
		days = Math.floor(seconds / (60*60*24));
		seconds -= days * (60*60*24);
	}
	if(seconds > 60*60) {
		hours = Math.floor(seconds / (60*60));
		seconds -= hours * (60*60);
	}
	if(seconds > 60) {
		minutes = Math.floor(seconds / 60);
		seconds -= minutes * 60;
	}
	seconds = Math.round(seconds);
	if(days > 0)
		duration.push(days + " days");
	if(hours > 0)
		duration.push(hours + " hours");
	if(minutes > 0)
		duration.push(minutes + " minutes");
	if(seconds > 0)
		duration.push(seconds + " seconds");
	return duration.splice(0, units).join(", ");
}

$(document).ready(function() {
	$.getJSON('servers', function(data) {
		$('#status').append('<table><tr><th>Server</th><th>Last post</th><th>Uptime</th><th>Load</th><th>Memory usage</th></tr></table>');
		var table = $('#status table');
		var now = new Date(data.timestamp);
		$.each(data.servers, function(id, server) {
			server.data.system.load = server.data.system.load.map(function (load) {
				return " " + Math.round(load*100) / 100;
			});
			table.append('<tr><td>' + server.name +'</td>'
				+'<td>'+ timeDiff(new Date(server.data.timestamp), now) +' ago</td>'
				+'<td>'+ timeToDuration(server.data.system.uptime) +'</td>'
				+'<td>'+ server.data.system.load +'</td>'
				+'<td>'+ Math.round((1 - (server.data.system.memory.free / server.data.system.memory.total))*100) +'%</td>'
			+'</tr>');
		});
	});
});
