FactoryGirl.define do
  factory :publisher do
    name { generate(:sentence) }
  end
end
