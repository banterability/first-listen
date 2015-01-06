fs = require 'fs'

getConfigOrDie = ->
  try
    config = JSON.parse fs.readFileSync 'config.json', encoding: 'utf-8'
  catch err
    throw err

  throw new Error 'Missing twitter config' unless config.twitter
  throw new Error 'Missing NPR config' unless config.npr
  config

module.exports = {getConfigOrDie}
