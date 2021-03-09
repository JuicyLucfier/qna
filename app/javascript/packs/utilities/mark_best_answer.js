$(document).on('turbolinks:load', function (){
    $('.answers').on('click', '.best-answer-link', function(e) {
        e.preventDefault();

        let best = $(this).data('best');
        let answerId = $(this).data('answerId');

        if(best === true){
            $(this).hide();
            $('best-answer-link#best-answer-' + answerId).removeClass('hidden');
        } else {
            $(this).removeClass('hidden')
            $('best-answer-link#best-answer-' + answerId).hide();
        }
    })
});
