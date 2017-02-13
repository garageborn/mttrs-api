FactoryGirl.define do
  factory :blocked_url do
    publisher
    matcher { generate(:domain) }
  end
end
