$(document).on('turbolinks:load', function () {
    $('.vote-block').on('ajax:success', '.vote', function (e) {
        var xhr = e.detail[0];
        var resourceName = xhr['resourceName'];
        var resourceId = xhr['resourceId'];
        var resourceScore = xhr['resourceScore'];

        $('.' + resourceName + '-' + resourceId + ' .vote-block .score').html(resourceScore);
    });
});
