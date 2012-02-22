config = require './config'

# Mongo DB config
console.log "Connecting to mongo at: #{config.mongoUri}"
mongo     = require('mongoskin')
db        = mongo.db config.mongoUri
servers   = db.collection('servers')
postbacks = db.collection('postbacks')

# set up mongo indices
servers.ensureIndex 'agent_key', {unique: true}, (err) ->
	console.log 'Error ensuring index on servers.agent_key: '+ err if err?
postbacks.ensureIndex 'server', (err) ->
	console.log 'Error ensuring index on postbacks.server: '+ err if err?
postbacks.ensureIndex {timestamp:-1}, (err) ->
	console.log 'Error ensuring index on postbacks.timestamp: '+ err if err?

# prune old postbacks
prunePostbacks = () ->
	if config.pruneEnabled
		pruneDate = new Date new Date().getTime() - 1000 * 60 * 60 * 24 * config.pruneAge
		console.log "Performing postback prune, deleting postbacks prior to #{pruneDate.toString()}"
		cursor = postbacks.find {"timestamp": {$lt: pruneDate}}
		cursor.count (err, count) ->
			if err?
				console.log "Error in postback prune: #{err}"
			else
				postbacks.remove {"timestamp": {$lt: pruneDate}}, (err) ->
					if err?
						console.log "Error in postback prune: #{err}"
					else
						console.log "Pruned #{count || 0} postbacks"

if config.pruneEnabled
	# prune now and every 2 hours
	prunePostbacks()
	setInterval prunePostbacks, 3600000 * 2

exports.servers = servers
exports.postbacks = postbacks
