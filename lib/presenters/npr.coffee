{find} = require 'underscore'

class StoryPresenter
  constructor: (@story) ->

  getId: ->
    @story.id

  getShortLink: ->
    shortLink = find @story.link, (link) ->
      link.type == "short"
    shortLink.$text

  getTitle: ->
    bestMatch = find [@_buildTitleFromProduct, @_buildTitleFromSong, @_buildTitleFromTitle], (func) -> func()
    bestMatch()

  present: ->
    id: @getId()
    link: @getShortLink()
    title: @getTitle()

  # First option (from Amazon/iTunes/etc links)
  _buildTitleFromProduct : =>
    albumInfo = @story.product?[0]
    artist = albumInfo?.author?.$text
    album = albumInfo?.title?.$text
    formatAlbumData artist, album

  # Second best option (metadata from first track)
  _buildTitleFromSong : =>
    albumInfo = @story.song?[0].album
    artist = albumInfo?.albumArtist?.$text
    album = albumInfo?.albumTitle?.$text
    formatAlbumData artist, album

  # Fallback option (splice up article title)
  _buildTitleFromTitle : =>
    albumInfo = @story.title.$text
    [_title, artist, album] = albumInfo.match /First Listen: (?:(.*)(?:, ))*'(.+)'/
    formatAlbumData artist, album

module.exports = StoryPresenter

formatAlbumData = (artist, album) ->
  if artist and album
    "“#{album}” by #{artist}"
  else if album
    "“#{album}”"
  else if artist
    artist
