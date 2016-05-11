"use strict";

const pollProcessing = function() {
  setTimeout(() => {
    $.get(window.location.href)
      .always((data, status, xhr) => {
        if (xhr.status == 202) {
          pollProcessing();
        } else {
          window.location.reload();
        }
      });
  }, 2000);
};

$(() => {
  if ($(".schedules-controller.processing-action").length)
    pollProcessing();
});

