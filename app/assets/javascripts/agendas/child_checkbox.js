"use strict";

export default class ChildCheckbox {
  constructor() {
    $("[data-child-checkbox]").each(this.bindCheckboxes.bind(this));
  }

  bindCheckboxes(index, checkbox) {
    const $checkbox = $(checkbox);
    const childCheckboxId = $checkbox.attr("data-child-checkbox");
    const $childCheckbox = $(`#${childCheckboxId}`);

    $checkbox.change(() => {
      if (!$checkbox.prop("checked")) { $childCheckbox.prop("checked", false); }
    });
    $childCheckbox.change(() => {
      if ($childCheckbox.prop("checked")) { $checkbox.prop("checked", true); }
    });
  }
}
