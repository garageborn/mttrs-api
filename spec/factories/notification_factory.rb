FactoryGirl.define do
  factory :notification do
    notificable { build(:link) }
    title { Faker::Lorem.sentence }
    message { Faker::Lorem.paragraph }
    image_url { generate(:url) }
  end
end
