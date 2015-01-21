async = require 'async'
fetchAlbums = require './lib/clients/npr'
{getConfigOrDie} = require './lib/config'
sendTweet = require './lib/clients/twitter'
{sortBy} = require 'underscore'
store = require './lib/store'
StoryPresenter = require './lib/presenters/npr'
TweetPresenter = require './lib/presenters/twitter'

config = getConfigOrDie()

console.log "\n------ start run: #{new Date} ------"

postTweetOrSkip = (story, callback) ->
  store.checkIfPosted story.id, (err, data) ->
    return callback(err) if err

    if data
      console.log "NPR##{story.id} already posted; doing nothing"
      return callback(null)
    else
      store.post story.id, (err, data) =>
        return callback(err) if err
        sendTweet config.twitter, new TweetPresenter(story).present(), (err, data) ->
          return callback(err) if err
          console.log "Posting NPR##{story.id} to Twitter"
          return callback(null)


fetchAlbums config.npr, (err, data) ->
  throw err if err

  stories = data.map (storyData) -> new StoryPresenter(storyData).present()

  async.eachSeries sortBy(stories, 'pubDate'), postTweetOrSkip, (err) ->
    throw err if err
    console.log "\n------ end run: #{new Date} ------\n"
    process.exit()
