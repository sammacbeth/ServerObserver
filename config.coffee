
exports.mongoUri = process.env.MONGOLAB_URI || 'localhost:27017/monly'
exports.port = process.env.PORT || 3000

# data pruning
exports.pruneEnabled = true
exports.pruneAge = 2
