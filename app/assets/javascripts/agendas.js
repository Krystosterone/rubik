"use strict";

import ChildCheckbox from "agendas/child_checkbox";
import LeaveNestedForm from "agendas/leave_nested_form";
import NestedForm from "agendas/nested_form";

$(() => {
  if (!$(".agendas-controller").length)
    return;

  new ChildCheckbox();
  new LeaveNestedForm();
  new NestedForm();
});
