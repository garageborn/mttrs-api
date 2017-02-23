FactoryGirl.define do
  factory :title_replacement do
    publisher
    matcher { Faker::Lorem.word }
  end
end
