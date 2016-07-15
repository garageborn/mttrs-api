FactoryGirl.define do
  factory :feed do
    publisher
    category
    url { generate(:url) }
  end
end
