$(document).on('.vote').on('ajax:success', function(e) {
    let rating = e.detail[0].rating
    let id = e.detail[0].id
    let voteValue = e.detail[0].vote_value
    let className = e.detail[0].class_name

    $('.rating-' + className + '-' + id).html('<p>' + rating + '</p>');

    if(voteValue === "for"){
        $('.vote-link#vote-for-' + className + '-' + id).addClass('hidden');
        $('.vote-link#vote-against-' + className + '-' + id).addClass('hidden');
        $('.voted-link#voted-against-' + className + '-' + id).addClass('hidden');
        $('.voted-link#voted-for-' + className + '-' + id).removeClass('hidden');
    } else if(voteValue === "against") {
        $('.vote-link#vote-for-' + className + '-' + id).addClass('hidden');
        $('.vote-link#vote-against-' + className + '-' + id).addClass('hidden');
        $('.voted-link#voted-for-' + className + '-' + id).addClass('hidden');
        $('.voted-link#voted-against-' + className + '-' + id).removeClass('hidden');
    } else {
        $('.voted-link#voted-against-' + className + '-' + id).addClass('hidden');
        $('.voted-link#voted-for-' + className + '-' + id).addClass('hidden');
        $('.vote-link#vote-for-' + className + '-' + id).removeClass('hidden');
        $('.vote-link#vote-against-' + className + '-' + id).removeClass('hidden');
    }
});
