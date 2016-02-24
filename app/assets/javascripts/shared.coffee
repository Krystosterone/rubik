$ ->
  $(document).on "submit", "#donation-modal form", (event) ->
    event.preventDefault()

    $form = $(event.currentTarget)
    $loading = $("<i>", class: "glyphicon glyphicon-refresh spinning")

    $form.find("[type=submit]").html($loading)
    $.ajax
      type: $form.attr("method")
      url: $form.attr("action")
      data: $form.serialize()
    .done (response) ->
      $form.replaceWith(response)
