$(document).on('turbolinks:load', function (){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    })
});