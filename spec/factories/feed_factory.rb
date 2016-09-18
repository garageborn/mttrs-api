FactoryGirl.define do
  factory :feed do
    publisher
    url { generate(:url) }
  end
end
