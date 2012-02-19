config = require './config'
ds = require './datastore'
qs = require('querystring')

# expressjs configuration
express = require('express')
app     = express.createServer()

app.configure () ->
	app.use express.methodOverride()
	app.use express.logger()
	app.use express.bodyParser()
	app.use app.router

app.post '/postback/', (request, response) ->
	if request.body? and request.body.payload?
		payload = JSON.parse request.body.payload
		if payload.agentKey?
			ds.servers.findOne {"agent_key": payload.agentKey}, (err, s) ->
				if err?
					console.log err
				else if s?
					data =
						server: s._id
						timestamp: new Date()
						payload: payload
					ds.postbacks.save data, {}, () ->

	# send a 203
	response.send();

app.listen config.port