FactoryGirl.define do
  factory :category do
    name { generate(:sentence) }
  end
end
