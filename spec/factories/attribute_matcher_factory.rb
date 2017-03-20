FactoryGirl.define do
  factory :attribute_matcher do
    publisher
    name { %w(title description image_source_url published_at language content).sample }
    matcher { Faker::Lorem.word }
  end
end
