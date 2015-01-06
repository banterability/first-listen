twitter = require 'twitter'

module.exports = (config, message, callback) ->
  return callback(new Error "Twitter configuration required", null) unless config

  tApi = new twitter config

  tApi.updateStatus message, (data) ->
    callback null, data
