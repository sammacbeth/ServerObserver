user = require './user'

exports.check_auth = (request, response, next, fail) ->
	console.log "check_auth"
	if request.session? and request.session.auth
		next request, response
	else
		fail request, response

exports.login = (request, response, next, fail) ->
	console.log "login"
	if request.body.username? and request.body.password?
		user.check_user request.body.username, request.body.password, (err, success) ->
			console.log err if err?
			if success
				console.log "Login success"
				request.session.auth = true
				next request, response
			else
				fail request, response
	else
		fail request, response
	
exports.logout = (request, response, next) ->
	request.session.destroy()
	next request, response
