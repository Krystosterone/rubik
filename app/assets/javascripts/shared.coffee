removeFallbackInput = ->
  $("[data-toggle='collapse']").each (index, toggle) ->
    $toggle = $(toggle)
    fallbackInput = $toggle.attr("for")

    $toggle.removeAttr("for")
    $("##{fallbackInput}").remove()

$ ->
  removeFallbackInput()
