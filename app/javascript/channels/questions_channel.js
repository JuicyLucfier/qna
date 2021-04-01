import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    console.log('Received!')
    $('.questions').append(data)
  }
})
