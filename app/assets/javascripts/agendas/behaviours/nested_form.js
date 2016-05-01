import $ from "vendor/jquery-2.2.3";

export default class NestedForm {
  constructor() {
    $("[data-nested-form] > *").attr("data-fields", "");
    $("[data-nested-form-create]").click(this.onCreateClick.bind(this));
    $(document).on("click", "[data-nested-form] [data-nested-form-destroy]", this.onDestroyClick.bind(this));
  }

  onCreateClick(event) {
    event.preventDefault();

    let $button = $(event.currentTarget);
    let association = $button.attr("data-nested-form-create");
    let $container = $(`[data-nested-form='${association}']`);
    let template = $(`[data-nested-form-template='${association}']`).html();
    let memberLength = $container.children().length;

    let $associationFields = $(template.replace(/\{\{index}}/g, `${memberLength}`)).attr("data-fields", "");
    $container.append($associationFields);
    $associationFields.trigger("create");
  }

  onDestroyClick(event) {
    event.preventDefault();

    let $button = $(event.currentTarget);
    let $fields = $button.closest("[data-fields]");
    let $input = $button.prev("[data-nested-form-destroy-input]");

    $input.removeAttr("disabled");
    $fields.css({"display": "none"});
    $fields.trigger("destroy");
  }
}
