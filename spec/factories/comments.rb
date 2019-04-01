FactoryBot.define do
  factory :comment do
    body { "Comment text" }

    trait :invalid do
      body { nil }
    end
  end
end
