# expressjs configuration
config = require './config'
express = require('express')
app     = express.createServer()
app.configure () ->
	app.use express.methodOverride()
	app.use express.logger()
	app.use express.bodyParser()
	app.use app.router
	
# routes
postback = require './postback'
server = require './server'

app.post '/postback/', postback.create
app.post '/server', server.create

app.listen config.port
