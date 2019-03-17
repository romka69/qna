FactoryBot.define do
  factory :badge do
    name { "MyTextBadge" }

    trait :with_img do
      img { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
    end
  end
end
