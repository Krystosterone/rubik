$ ->
  $(".agendas-controller [data-nested-form] > *").attr("data-fields", "")

  $(".agendas-controller [data-nested-form-create]").click (event) ->
    event.preventDefault()

    $button = $(event.currentTarget)
    association = $button.attr("data-nested-form-create")
    $container = $("[data-nested-form='#{association}']")
    template = $("[data-nested-form-template='#{association}']").html()
    memberLength = $container.children().length

    associationFields = $(template.replace(/\{\{index}}/g, "#{memberLength}")).attr("data-fields", "")
    $container.append(associationFields)

  $(document).on "click", ".agendas-controller [data-nested-form-destroy]", (event) ->
    event.preventDefault()

    $button = $(event.currentTarget)
    $fields = $button.closest("[data-fields]")
    $input = $button.prev("[data-nested-form-destroy-input]")

    $input.removeAttr("disabled")
    $fields.css(display: "none")
