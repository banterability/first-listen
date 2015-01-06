request = require 'request'

module.exports = ({apiKey}, callback) ->

  return callback(new Error "NPR API Key required", null) unless apiKey

  requestOptions =
    url: "http://api.npr.org/query"
    json: true
    qs:
      id: 98679384
      apiKey: apiKey
      output: 'json'

  request.get requestOptions, (err, res, body) ->
    return callback err, null if err?

    callback null, body.list.story
