# expressjs configuration
config  = require './config'
express = require('express')
auth    = require './auth'
app     = express.createServer(
	express.methodOverride(),
	express.logger(),
	express.cookieParser(),
	express.session({ secret: 'thisissecret' }),
	express.bodyParser()
)
app.set 'view engine', 'jade'
app.set 'view options', { layout: false }

# general responses
deny = (request, response) ->
	response.send 403

login_redirect = (request, response) ->
	response.redirect '/login'

index_redirect = (request, response) ->
	response.redirect '/'

# routes
postback = require './postback'
server = require './server'

app.get '/', (req, res) ->
	auth.check_auth req, res, (req, res) ->
		res.render 'index'
	, login_redirect
app.post '/postback/', postback.create
app.post '/server', (req, res) ->
	auth.check_auth req, res, server.create, deny
app.get '/login', (req, res) ->
	auth.check_auth req, res, index_redirect, (rq, rs) ->
		rs.render 'login'
app.post '/login', (req, res) ->
	auth.login req, res, index_redirect, login_redirect

app.listen config.port
