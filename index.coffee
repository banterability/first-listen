{getConfigOrDie} = require './lib/config'
fetchAlbums = require './lib/clients/npr'
sendTweet = require './lib/clients/twitter'
StoryPresenter = require './lib/presenters/npr'
TweetPresenter = require './lib/presenters/twitter'

config = getConfigOrDie()

fetchAlbums config.npr, (err, data) ->
  throw err if err?
  data.forEach (story) ->
    # TODO: if not yet posted to twitter
    sendTweet config.twitter, new TweetPresenter(new StoryPresenter(story).present()).present(), (err, data) ->
      console.log 'tweet posted'