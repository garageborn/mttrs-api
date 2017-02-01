FactoryGirl.define do
  factory :publisher_domain do
    publisher
    domain { generate(:domain) }
  end
end
