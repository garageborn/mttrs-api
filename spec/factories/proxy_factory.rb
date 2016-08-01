FactoryGirl.define do
  factory :proxy do
    ip { generate(:ip) }
    port 80
  end
end
