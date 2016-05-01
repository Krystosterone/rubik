import NestedForm from "agendas/behaviours/nested_form";
import LeaveNestedForm from "agendas/behaviours/leave_nested_form";

$(() => {
  if (!$(".agendas-controller").length)
    return;

  new NestedForm();
  new LeaveNestedForm();
});
