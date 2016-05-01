import $ from "vendor/jquery-2.2.3";

$(() => {
  if (!$(".schedules-controller.processing-action").length)
    return;

  setTimeout(() => location.reload(), 2000);
});

