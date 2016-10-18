FactoryGirl.define do
  factory :publisher do
    name { generate(:sentence) }
    domain { generate(:domain) }
  end
end
