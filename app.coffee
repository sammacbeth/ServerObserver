# Mongo DB config
mongo     = require('mongoskin')
db        = mongo.db('localhost:27017/monly')
servers   = db.collection('servers')
postbacks = db.collection('postbacks')

# set up mongo indices
servers.ensureIndex 'agent_key', (err) ->
	console.log 'Error ensuring index on servers.agent_key: '+ err if err?
postbacks.ensureIndex 'server', (err) ->
	console.log 'Error ensuring index on postbacks.server: '+ err if err?
postbacks.ensureIndex 'timestamp', (err) ->
	console.log 'Error ensuring index on postbacks.timestamp: '+ err if err?

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
			servers.findOne {"agent_key": payload.agentKey}, (err, s) ->
				if err?
					console.log err
				else if s?
					data =
						server: s._id
						timestamp: new Date()
						payload: payload
					postbacks.save data, {}, () ->

	# send a 203
	response.send();

app.listen 3000