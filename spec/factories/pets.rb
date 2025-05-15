FactoryBot.define do
  factory :pet do
    name { "MyString" }
    species { "MyString" }
    breed { "MyString" }
    age { 1 }
    description { "MyText" }
    status { 1 }
  end
end
