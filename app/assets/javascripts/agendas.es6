$(() => {
  $(".agendas-controller body [data-nested-form] > *").attr("data-fields", "");

  $(".agendas-controller body [data-nested-form-create]").click((event) => {
    event.preventDefault();

    var $button = $(event.currentTarget);
    var association = $button.attr("data-nested-form-create");
    var $container = $(`[data-nested-form='${association}']`);
    var template = $(`[data-nested-form-template='${association}']`).html();
    var memberLength = $container.children().length;

    var associationFields = $(template.replace(/\{\{index}}/g, `${memberLength}`)).attr("data-fields", "");
    $container.append(associationFields);
  });

  $(document).on("click", ".agendas-controller body [data-nested-form-destroy]", (event) => {
    event.preventDefault()

    var $button = $(event.currentTarget);
    var $fields = $button.closest("[data-fields]");
    var $input = $button.prev("[data-nested-form-destroy-input]");

    $input.removeAttr("disabled");
    $fields.css({"display": "none"});
  });
});
