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
        });

    App.cable.subscriptions.create('CommentChannel', {
        connected: function() {
            var questionId = $('.question').data('resource-id');
            return this.perform('follow', {id: questionId});
        },
        received: function(data) {
            if (gon.user_id != data.comment.author_id) {
                var resourceName = data.comment.commentable_type;
                var resourceId = data.comment.commentable_id;
                var newComment = JST['templates/comment']({comment: data.comment});

                if (resourceName == 'Question') {
                    $('.question .comment-block .comments').append(newComment);
                } else if (resourceName == 'Answer') {
                    $('.answers .answer-' + resourceId + ' .comment-block .comments').append(newComment);
                }
            }
        }
    });
});
