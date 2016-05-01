import $ from "vendor/jquery-2.2.3";
import NestedForm from "agendas/behaviours/nested_form";
import LeaveNestedForm from "agendas/behaviours/leave_nested_form";

$(() => {
  if (!$(".agendas-controller").length)
    return;

  new NestedForm();
  new LeaveNestedForm();
});
