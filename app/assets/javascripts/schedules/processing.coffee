$ ->
  return unless $(".schedules-controller.processing-action").length

  reload = -> location.reload()
  setTimeout reload, 2000
