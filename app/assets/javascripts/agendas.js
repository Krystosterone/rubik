"use strict";

import NestedForm from "agendas/nested_form";
import LeaveNestedForm from "agendas/leave_nested_form";

$(() => {
  if (!$(".agendas-controller").length)
    return;

  new NestedForm();
  new LeaveNestedForm();
});
