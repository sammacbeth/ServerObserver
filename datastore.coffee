config = require './config'

# Mongo DB config
console.log "Connecting to mongo at: #{config.mongoUri}"
mongo     = require('mongoskin')
db        = mongo.db config.mongoUri
servers   = db.collection('servers')
postbacks = db.collection('postbacks')

# set up mongo indices
servers.ensureIndex 'agent_key', (err) ->
	console.log 'Error ensuring index on servers.agent_key: '+ err if err?
postbacks.ensureIndex 'server', (err) ->
	console.log 'Error ensuring index on postbacks.server: '+ err if err?
postbacks.ensureIndex 'timestamp', (err) ->
	console.log 'Error ensuring index on postbacks.timestamp: '+ err if err?

exports.servers = servers
exports.postbacks = postbacks