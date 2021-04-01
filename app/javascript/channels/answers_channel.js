import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if (gon.question_id) {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      received(data) {
        console.log(data, gon.user_id)
        const template = require('answer.hbs')
        if (gon.user_id !== data.author_id) {
          $('.answers').append(template(data),'<hr>')
        }
      }
    });
  }
})
