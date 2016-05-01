export default class LeaveNestedForm {
  constructor() {
    $("[data-nested-form='leaves'] > [data-fields]").each(this.onFieldsInit.bind(this));
    $(document).on("create", "[data-nested-form='leaves'] > [data-fields]", this.onCreate.bind(this));
    $(document).on("change", "[data-nested-form='leaves'] [data-leave-starts-at]", this.onLeaveStartsChange.bind(this));
  }

  onFieldsInit(index, fields) {
    let $fields = $(fields);

    this.setDataOptions($fields);
    this.restrictEndsAtSelect($fields.find("[data-leave-starts-at]"));
  }

  onCreate(event) {
    let $fields = $(event.currentTarget);

    this.setDataOptions($fields);
    this.restrictEndsAtSelect($fields.find("[data-leave-starts-at]"));
  }

  onLeaveStartsChange(event) {
    this.restrictEndsAtSelect(event.currentTarget);
  }

  setDataOptions($fields) {
    let $endsAtSelect = $fields.find("[data-leave-ends-at]");

    $endsAtSelect.attr("data-options", $endsAtSelect.html());
  }

  restrictEndsAtSelect(startsAtSelect) {
    let $startsAtSelect = $(startsAtSelect);
    let startsAtSelectedValue = parseInt($startsAtSelect.val());
    let index = $startsAtSelect.attr("data-leave-starts-at");
    let $endsAtSelect = $(`[data-leave-ends-at='${index}']`);
    let endsAtSelectedValue = $endsAtSelect.val();

    $endsAtSelect
      .html($endsAtSelect.attr("data-options"))
      .find("option")
      .each((index, option) => {
        let $option = $(option);
        let shouldRemove = parseInt($option.val()) <= startsAtSelectedValue;

        if (shouldRemove)
          $option.remove();

        if ($option.val() === endsAtSelectedValue)
          $option.prop("selected", true);
      });
  }
}
