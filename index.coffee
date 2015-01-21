fetchAlbums = require './lib/clients/npr'
{getConfigOrDie} = require './lib/config'
sendTweet = require './lib/clients/twitter'
{sortBy} = require 'underscore'
store = require './lib/store'
StoryPresenter = require './lib/presenters/npr'
TweetPresenter = require './lib/presenters/twitter'

config = getConfigOrDie()

fetchAlbums config.npr, (err, data) ->
  throw err if err?
  stories = data.map (storyData) -> new StoryPresenter(storyData).present()
  sortBy(stories, 'pubDate').forEach (story) ->
    store.checkIfPosted story.id, (err, data) ->
      if data
        console.log "NPR##{story.id} already posted; doing nothing"
      else
        store.post story.id, (err, data) =>
          sendTweet config.twitter, new TweetPresenter(story).present(), (err, data) ->
            console.log "Posting NPR##{story.id} to Twitter"
