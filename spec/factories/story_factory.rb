FactoryGirl.define do
  factory :story do
    total_social { Faker::Number.number(5).to_i }
    published_at { Time.zone.now }
  end
end
