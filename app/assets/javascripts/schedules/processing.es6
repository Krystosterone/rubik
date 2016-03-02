$(() => {
  if (!$(".schedules-controller.processing-action").length)
    return;

  setTimeout(() => location.reload(), 2000);
});

