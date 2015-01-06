request = require 'request'

module.exports = ({apiKey}, callback) ->

  return callback(new Error "NPR API Key required", null) unless apiKey

  requestOptions =
    url: "http://api.npr.org/query"
    json: true
    qs:
      apiKey: apiKey
      id: 98679384
      output: 'json'
      sort: 'dateDesc'
      numResults: 20

  request.get requestOptions, (err, res, body) ->
    return callback err, null if err?

    callback null, body.list.story
