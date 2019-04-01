$(document).on('turbolinks:load', function () {
    $('.new-comment').on('ajax:success', function(e) {
        var xhr = e.detail[0];
        var resourceName = xhr['commentable_type'].toLowerCase();
        var resourceId = xhr['commentable_id'];
        var resourceContent = xhr['body'];

        $('.' + resourceName + '-' + resourceId + ' .comment-block .comments').append('<div class="comment"><p>'+ resourceContent + '</p></div>');
    })
        .on('ajax:error', function(e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.comment-errors').append('<p>' + index + ' ' + value + '<p>');
            })
        })
});
