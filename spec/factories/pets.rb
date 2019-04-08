FactoryBot.define do
  factory :pet do
    name { "Doggo" }
    photo_urls { ["MyString", "MyOtherString"] }
    status { "available" }
  end
end
