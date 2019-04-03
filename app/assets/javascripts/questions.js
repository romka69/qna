$(document).on('turbolinks:load', function () {
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });

    App.cable.subscriptions.create('QuestionChannel', {
        connected: function() {
            return this.perform('follow');
        },
        received: function(data) {
            $('.questions').append(data);
        }
    })
});
