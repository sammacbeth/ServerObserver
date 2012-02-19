ds = require './datastore'

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
