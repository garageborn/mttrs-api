FactoryGirl.define do
  factory :category do
    name { generate(:sentence) }
    image_id { Faker::Number.number(10) }
    color { Faker::Color.hex_color }
  end
end
