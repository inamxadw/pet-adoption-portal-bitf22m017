FactoryBot.define do
  factory :adoption_application do
    user { nil }
    pet { nil }
    status { 1 }
    notes { "MyText" }
  end
end
