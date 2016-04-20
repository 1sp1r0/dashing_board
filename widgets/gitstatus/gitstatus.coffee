class Dashing.Gitstatus extends Dashing.Widget

  ready: ->
    $(@node).find(".myiframe").attr('src', @get('src'))

  onData: (data) ->
    $(@node).find(".myiframe").attr('src', data.src)