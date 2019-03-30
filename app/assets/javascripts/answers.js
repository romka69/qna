$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    App.cable.subscriptions.create('AnswerChannel', {
        connected: function() {
            var questionId = $('.question')[0].classList[1].slice(-1);
            return this.perform('follow', {question_id: questionId});
        },
        received: function(data) {
            if (gon.user_id != data.answer.author_id) {
                var newAnswer = JST['templates/answer']({
                    answer: data.answer,
                    links: data.links,
                    files: data.files
                });
                $('.answers').append(newAnswer);
                console.log(data);
            }
        }
    });
});
