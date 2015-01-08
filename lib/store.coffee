Redis = require 'redis'
store = Redis.createClient()

module.exports =
  checkIfPosted: (id, cb) ->
    store.get "first-listen:posted:#{id}", cb

  post: (id, cb) ->
    store.set "first-listen:posted:#{id}", +(new Date()), cb
