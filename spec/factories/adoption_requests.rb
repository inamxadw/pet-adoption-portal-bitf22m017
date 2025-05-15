FactoryBot.define do
  factory :adoption_request do
    user { nil }
    pet { nil }
    status { 1 }
    message { "MyText" }
  end
end
