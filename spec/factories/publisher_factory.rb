FactoryGirl.define do
  factory :publisher do
    name { generate(:sentence) }
    icon_id { Faker::Number.number(10) }
  end
end
