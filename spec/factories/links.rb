FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://gist.github.com/romka69/54370693ce6554b1afceaf0ef0076d36" }

    trait :invalid do
      url { "https://ya.ru" }
    end
  end
end
