//= require jquery2
//= require bootstrap-sprockets

"use strict";

import "agendas";
import "schedules/processing";

window.onpageshow = function(event) {
  if (event.persisted) { window.location.reload(); }
};
