{find} = require 'underscore'

class StoryPresenter
  constructor: (@story) ->

  getShortLink: ->
    shortLink = find @story.link, (link) ->
      link.type == "short"
    shortLink.$text

  getTitle: ->
    @story.title.$text.replace 'First Listen: ', ''

  present: ->
    title: @getTitle()
    link: @getShortLink()

module.exports = StoryPresenter
