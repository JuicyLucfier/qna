import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if (gon.question_id) {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      connected() {
        console.log('Connected!')
      },

      received(data) {
        console.log(data)
        const template = require('answer.hbs')
        if (gon.user_id != data.author_id) {
          $('.answers').append(template(data),'<hr>')
        }
      }
    });
  }
})
