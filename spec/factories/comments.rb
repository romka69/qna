FactoryBot.define do
  factory :comment do
    comment_body { "Comment text" }

    trait :invalid do
      comment_body { nil }
    end
  end
end
