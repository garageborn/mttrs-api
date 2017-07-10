FactoryGirl.define do
  factory :category do
    name { generate(:sentence) }
    color { Faker::Color.hex_color }
  end
end
