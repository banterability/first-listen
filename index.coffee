fetchAlbums = require './lib/clients/npr'
{getConfigOrDie} = require './lib/config'
sendTweet = require './lib/clients/twitter'
store = require './lib/store'
StoryPresenter = require './lib/presenters/npr'
TweetPresenter = require './lib/presenters/twitter'

config = getConfigOrDie()

fetchAlbums config.npr, (err, data) ->
  throw err if err?
  data.forEach (storyObj) ->
    story = new StoryPresenter(storyObj).present()

    store.checkIfPosted story.id, (err, data) ->
      if data
        console.log "NPR##{story.id} already posted; doing nothing"
      else
        store.post story.id, (err, data) =>
          sendTweet config.twitter, new TweetPresenter(story).present(), (err, data) ->
            console.log "Posting NPR##{story.id} to Twitter"
