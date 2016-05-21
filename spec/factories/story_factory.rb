FactoryGirl.define do
  factory :story do
    publisher
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    url { generate(:url) }
    source_url { generate(:url) }
  end
end
