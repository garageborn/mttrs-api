FactoryGirl.define do
  factory :tag do
    category
    name { generate(:sentence) }
  end
end
