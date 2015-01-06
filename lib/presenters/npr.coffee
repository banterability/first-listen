{find} = require 'underscore'

class StoryPresenter
  constructor: (@story) ->

  getShortLink: ->
    shortLink = find @story.link, (link) ->
      link.type == "short"
    shortLink.$text

  getTitle: ->
    bestMatch = find [buildTitleFromSong, buildTitleFromProduct, buildTitleFromTitle], (func) => func(@story)
    bestMatch(@story)

  present: ->
    link: @getShortLink()
    title: @getTitle()

module.exports = StoryPresenter

formatAlbumData = (artist, album) ->
  if artist and album
    "“#{album}” by #{artist}"
  else if album
    "“#{album}”"
  else if artist
    artist

buildTitleFromTitle = (story) ->
  albumInfo = story.title.$text
  [_title, artist, album] = albumInfo.match /First Listen: (?:(.*)(?:, ))*'(.+)'/
  formatAlbumData artist, album

buildTitleFromSong = (story) ->
  albumInfo = story.song?[0].album
  artist = albumInfo?.albumArtist?.$text
  album = albumInfo?.albumTitle?.$text
  formatAlbumData artist, album

buildTitleFromProduct = (story) ->
  albumInfo = story.product?[0]
  artist = albumInfo?.author?.$text
  album = albumInfo?.title?.$text
  formatAlbumData artist, album
