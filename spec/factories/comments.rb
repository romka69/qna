FactoryBot.define do
  factory :comment do
    comment_body { "Comment text" }

    trait :invalid do
      comment_body { nil }
    end
  end

  factory :question_comment, class: Comment do
    association :commentable, factory: :question
    body { "Comment text" }
  end
end
