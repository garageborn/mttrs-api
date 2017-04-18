FactoryGirl.define do
  factory :notification do
    notificable { build(:link) }
    segment { 'mttrs_us test' }
    title { Faker::Lorem.sentence }
    message { Faker::Lorem.paragraph }
    image_url { generate(:url) }
  end
end
