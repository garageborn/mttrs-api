FactoryGirl.define do
  factory :publisher do
    name { generate(:sentence) }
    domain { Faker::Internet.domain_name }
  end
end
