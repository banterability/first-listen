class TweetPresenter
  constructor: (@context) ->

  present: ->
    "♫ #{@context.title}: #{@context.link}"


module.exports = TweetPresenter
