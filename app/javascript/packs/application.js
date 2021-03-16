// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

require("@nathanvda/cocoon")

var jQuery = require("jquery");
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

require("packs/utilities/edit_answer")
require("packs/utilities/edit_question")
require("packs/utilities/mark_best_answer")

Rails.start()
Turbolinks.start()
ActiveStorage.start()
