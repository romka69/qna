$(document).on('turbolinks:load', function () {

    $('.question').on('ajax:success', '.vote', function (e) {
        var xhr = e.detail[0];
        var resourceId = xhr['resourceId'];
        var scoreResource = xhr['resourceScore'];

        $('.question-' + resourceId + ' .vote-block .score').html(scoreResource);
    });

    $('.answers').on('ajax:success', '.vote', function (e) {
        var xhr = e.detail[0];
        var resourceId = xhr['resourceId'];
        var scoreResource = xhr['resourceScore'];

        $('.answer-' + resourceId + ' .vote-block .score').html(scoreResource);
    });
});
