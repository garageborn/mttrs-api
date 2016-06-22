FactoryGirl.define do
  factory :link do
    publisher
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    url { generate(:url) }
    source_url { generate(:url) }
    published_at { Time.zone.now }
  end
end
