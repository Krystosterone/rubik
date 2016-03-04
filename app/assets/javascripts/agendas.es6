//= require agendas/behaviours/nested_form
//= require agendas/behaviours/leave_nested_form

$(() => {
  if (!$(".agendas-controller").length)
    return;

  new NestedForm();
  new LeaveNestedForm();
});
