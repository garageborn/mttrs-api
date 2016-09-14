FactoryGirl.define do
  factory :link do
    publisher
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    published_at { Time.zone.now }
  end
end
