ds = require './datastore'
bcrypt = require 'bcrypt'

salt_rounds = 10

console.log bcrypt

username_regex = /\w{3,}$/g
password_regex = /\S{7,}$/g
valid_username = (username) ->
	username? and username.length > 2 and username_regex.test username

valid_password = (password) ->
	password? and password.length > 6 and password_regex.test password

exports.create = (username, password, callback) ->
	if not valid_username username or not valid_password password
		callback 'Bad username or password'
	else
		# check username doesn't exist
		cursor = ds.users.find {"username": username}
		cursor.count (err, count) ->
			if count > 0
				callback "user already exists"
			else
				# generate password salt/hash
				salt = bcrypt.gen_salt_sync salt_rounds
				hash = bcrypt.encrypt_sync password, salt
				user = 
					username: username
					passhash: hash
				ds.users.save user, {safe:true}, callback

exports.check_user = (username, password, callback) ->
	if not valid_username username or not valid_password password
		callback 'Bad username or password'
	else
		ds.users.findOne {"username": username}, (err, user) ->
			if err?
				callback err
			else if not user?
				callback "User does not exist"
			else
				bcrypt.compare password, user.passhash, callback

# create root user on startup if no users exist
console.log "Checking users"
cursor = ds.users.find()
cursor.count (err, count) ->
	if err?
		console.log "Error checking users"
	console.log "Found #{count} users"
	if count == 0
		console.log "Found no existing users, creating root account"
		user = "root"
		password = "admin"
		exports.create user, password, (err) ->
			console.log "Created user #{user}, password #{password}"

