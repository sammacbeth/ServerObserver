ds = require './datastore'
async = require 'async'

exports.create = (request, response) ->
	if request.body?
		console.log request.body
		ds.servers.save request.body, {safe: true}, (err) ->
			if err?
				console.log err
				response.send 500
			else
				response.send 201
	else
		response.send 400

exports.list = (request, response) ->
	ds.servers.find().toArray (err, rawServers) ->
		if err?
			console.log err
			response.send 500
		else
			async.map rawServers, (s, cb) ->
				sData =
					name: s.name
				cursor = ds.postbacks.find {server: s._id}, {"sort": [['timestamp', 'desc']]}
				cursor.count (err, count) ->
					if count > 0
						cursor.nextObject (err, p) ->
							if err
								cb err
							sData.timestamp = p.timestamp
							sData.uptime = p.payload.system.uptime
							sData.load = p.payload.system.load
							cb null, sData
					else
						cb null, sData
			, (err, servers) ->
				response.send
					servers: servers