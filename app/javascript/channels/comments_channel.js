import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if (gon.question_id) {
    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
      received(data) {
        if (gon.user_id != data.author_id) {
          $('.' + data.commentable_type + '-comments-' + data.commentable_id).append(data.body)
        }
      }
    })
  }
})
