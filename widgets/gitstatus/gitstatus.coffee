class Dashing.Gitstatus extends Dashing.Widget

  ready: ->
    $(@node).find(".iframe1").attr('src', @get('srcone'))
    $(@node).find(".iframe2").attr('src', @get('srctwo'))

  onData: (data) ->
    $(@node).find(".iframe1").attr('src', data.srcone)
    $(@node).find(".iframe2").attr('src', data.srctwo)